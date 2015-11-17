---
layout: post
title:  "Code with the Least Privilege"
date:   2015-11-16 22:37:07
tags: code ideas minimalist
---

There is a principle in computer science called the Principle of Least
Privilege. It was originally applied to security as a recommendation for
giving any process, user or program the least access possible. I think this
idea should also be applied to your code. You should **restrict your code as
much as possible.**

The idea behind the standard Principle of Least Privilege is straight forward
and typically applied to security. The wider the surface area of any system the
more that can be attacked by hackers. By using the lowest permissions possible
for any user, process, service or server reduces what is exposed if they were
compromised.

Great. So we can apply the idea to code too. Restrict what exactly? The
visibility between classes/assemblies. What is exposed at this level defines
their public API.

You should be very intentional with what you make public. Anything you make
public will need to be supported and maintained. Once made public removing or
changing what is exposed without break changes is harder. Having a bigger API
has more chances to expose the code you will later want to change.

For this reason I favour minimalist APIs. Everything not public can be more easily
refactored and improved. By keeping as much code private/internal you can you
decrease the surface area of the public API.

In this post I am going to go show how to use the keywords in C# to restrict
your code as much as possible. While you can apply the sane ideas to APIs, I
will focus on backend code here. Continue for several examples inspired by code
we use daily which highlight different techniques for controlling your code to
only allow the behaviour and visibility you want.

A simple example: A Factory
===============================================================================

Lets try a simple example. If you have a factory class you wouldn't keep the
original factory public would you?

{% highlight csharp %}
public class WidgetFactory {
    IWidget Create() {
        return new CoolWidget();
    }
}

public class CoolWidget : IWidget {
    ...
}
{% endhighlight %}

If ``CoolWidget`` is public then why would you need the factory? People could
start calling the class directly which would make the factory unnecessary. Or
unneeded until you want to change the type created by the ``WidgetFactory``.
By exposing ``CoolWidget`` you make it harder to change the widgets.

Instead ``CoolWidget`` should be internal! Much better.

{% highlight csharp %}
internal class CoolWidget : IWidget {
    ...
}
{% endhighlight %}

Hide Internals: A Worker Class
===============================================================================

Doing work in classes can get complicated. I looked through a whole bunch of
our code and found we often use private methods for doing little bits of work.

We had worker classes which would process queued work then send callbacks.
Within the class there was a handy method for sending callbacks.
It used other classes to do the real heavy lifting. The helpers method would
format the callback url and other parameters.

{% highlight csharp %}
public class Worker {
    public void Process( Work work ) {
        ...
        SendCallback( work.CallbackUrl )
    }

    public void SendCallback( Uri url ) {
        ...
    }
}
{% endhighlight %}

The sample above doesn't make sense. Why would ``SendCallback`` be public? It
doesn't fit with the purpose of the rest of the class. The method is only used
for one reason and benefits from being isolated from the rest of the Worker
class while still being related enough to the other code to stay there. Since
we would never want other classes using the method, it should be private!

{% highlight csharp %}
public class Worker {
    private void SendCallback( Uri url ) { ... }
}
{% endhighlight %}

Much better. Had we left this method public it could accidentally be used.
Keeping it private allows it to continue to evolve with the class it supports.

Sounds good right? There is a catch, testing these methods is harder. You can't
test them directly because they are now private. Instead you need to test them
indirectly through the inputs/outputs on the other methods or their behaviours.
If the logic is really complicated you might want to pull it out into it's own
classes and interfaces.

In the example above we have separated actually sending the callback into a
different class. This lets us test the two classes separately and better
isolate the logic for sending callbacks. The private method is still useful
and allows us to prepare the ``Payload``. The resulting helper classes look
like this:

{% highlight csharp %}
internal interface ISender {
    void SendCallback( Uri url, Payload payload );
}

internal class Sender {
    void SendCallback( Uri url, Payload payload ) { ... }
}
{% endhighlight %}

This lets us keep the logic testable yet keeps the external API small. There
are now more classes which might make the code more complicated.

We intentionally keep these helper classes internal. While they are useful they
have been created just for use within this assembly. Right now we don't think
anyone else would want to send their callbacks the same way and otherwise it
doesn't belong in the API.

Inheritance: No Family History
===============================================================================

Controlling inheritance is useful. Most developers I work with avoid using it
like the plague due to issues they had in the past. [Composition over inheritance][coi]
is not only recommended, it is enforced by marking most classes as ``sealed``:

{% highlight csharp %}
public sealed class CantTouchThis { }
{% endhighlight %}

Marking classes as ``sealed`` prevents them from being inherited which can lock
down bad inheritance. To be honest I think it is overkill since there
are very few cases where you want to explicitly block inheritance. More often
than not you don't have to worry about it. People don't willy nilly start
inheriting from classes.

Inheritance: Template Class
===============================================================================

Base classes can be useful. I use them to setup [template methods][templates]
or share common/optional functionality. This isn't often and I like to treat it
as yet another tool which can be used.

To enforce the purpose you envisioned for your base classes I recommend using
``abstract`` classes/methods. It ensures your desired methods must be
implemented by child classes. The base class itself cannot be instantiated
which further clarifies its purpose.

{% highlight csharp %}
public abstract class TaxesCalculatorBase {

    public decimal CalculateTaxes() {
        ...
        decimal multiplier = GetTaxesMultiplier( totalIncome );
        ...
    }

    protected decimal abstract GetTaxesMultiplier( decimal totalIncome );
}

public sealed class FlatTaxesCalculator : TaxesCalculatorBase {

    protected override GetTaxesMultiplier( decimal totalIncome ) {
        return 0.05;
    }
}

public sealed class ProgressiveTaxesCalculator : TaxesCalculatorBase{

    protected override GetTaxesMultiplier( decimal totalIncome ) {
        if( totalIncome > 75000) {
            return 0.15;
        } else if( totalIncome > 50000) {
            return 0.12;
        } else if( totalIncome > 25000) {
            return 0.08;
        } else
            return 0.05;
        }
    }
}
{% endhighlight %}

The ``TaxesCalculatorBase`` is an abstract class with the template method
``CalculateTaxes`` which uses the abstract ``GetTaxesMultiplier`` method.
This forces classes inheriting from ``TaxesCalculatorBase`` to implement
the required methods however they like. To prevent the hierarchy from
growing out of hand you can optionally mark the child classes as ``sealed``.

Another great usage is implementing common or optional functions in the base
class. I used
this recently to make optionally implementing part of an API easier. The class
had a method to return an ``IEnumerable`` which would be empty in the base
implementation. When they were ready child classes could
override the method to provide new functionality.

{% highlight csharp %}
public class ExampleProviderBase {
    public virtual IEnumerable<IExample> GetExamples() {
        return Enumerable.Empty<IExample>();
    }
}
{% endhighlight %}

All Action: Helper Classes
===============================================================================

Every now and then we have ``Helper`` classes with only methods and no state.
Stateless classes with helper methods can be made ``static`` to prevent them
from being instantiated or having instance variables added. If you had a
helper classes for ``Uri``'s it might look like this:

{% highlight csharp %}
internal static class UrlHelpers {
    public static Uri FormatUri( Uri baseUrl, string route ) { ... }

    public static Uri TruncateUri( Uri baseUrl ) { ... }

    public static Uri SomethingWithAUri( Uri baseUrl ) { ... }
}
{% endhighlight %}

The ``static`` constraint helps the class stay functional. Having the class be
``static`` ensures all the methods must also be declared as ``static``.

Manage state: Immutable Classes
===============================================================================

I think it is worth the minor effort to control whether fields/properties can
be modified. Limiting the number of ways data can be modified and passed around
can help highlight the right way to use your classes.

In this simple example I have made a ``Person`` class which is immutable. If this
data was stored in a database, you would have other classes for retrieving and
updating. Anyone trying to create a ``Person`` must provide the necessary fields
which prevent invalid objects from being created.

{% highlight csharp %}
public sealed class Person {
    public string FirstName { get; private set; }
    public string LastName { get; private set; }

    public Person( string first, string last ) {
        FirstName = first;
        LastName = last;
    }
}
{% endhighlight %}

You can take this even further if you would like. I used properties to make
writing ``FirstName`` and ``LastName`` easier. You can just as easily use
``readonly`` to only allow the fields to be initialized in the constructor.
This further enforces the class being created as immutable with extra help
from the compiler.

{% highlight csharp %}
public sealed class Person {
    private readonly string m_firstName;
    private readonly string m_lastName;

    public string FirstName { get { return m_firstName; } }
    public string LastName { get { return m_lastName; } }

    public Person( string first, string last ) {
        m_firstName = first;
        m_lastName = last;
    }
}
{% endhighlight %}

Another great immutability technique is to create a new object after every
method which would otherwise modify the current object. A great example of this
is the ``DateTime`` and ``string`` classes:

{% highlight csharp %}
DateTime now = DateTime.Now;
DateTime future = now.AddDays( 2.5 );

if( now == future ) {
    Console.WriteLine( "The future {0} is different than now {1}", future, now );
}

string example = "Hello World";
string updated = example.Replace( "l", "" );

if( updated == "Heo Word" ) {
    Console.WriteLine( "The example phrase was updated!")
}
{% endhighlight %}

Immutable classes strongly shape how users interact with them. They can
reinforce readonly parts of the system and highlight how you actually want data
to be updated.

TODO: Show off the new C# 6 options.

Generics: A different Animal
===============================================================================

When using generics I try to include any applicable constraints. They don't
come up often, but the little extra treatment to add constraints ensures they
values they contain match your expectations.

TODO: Finish and Test

{% highlight csharp %}
// All instances of T must be a reference type
public class ClassyList<T> where T: class {}

// T is both an Exception and has a default constructor
public class ExceptionThrower<T> where T: Exception, new() {}

public interface IFactory<T> where T : class { }

public class DefaultFactory<T> : IFactory<T>, where T: new() {
    public T Create() {
        return new T();
    }
}

public class Adapter<T,V> {
    
}
{% endhighlight %}

Conclusion
===============================================================================

Minimize API. Use the language to your advantage to do exactly what you want.

Everything should be private/internal.
Be very intentional about what is made public.

Minimalist APIs

[templates]: https://sourcemaking.com/design_patterns/template_method
[coi]: https://en.wikipedia.org/wiki/Composition_over_inheritance
[generics]: https://msdn.microsoft.com/en-us/library/d5x73970.aspx
