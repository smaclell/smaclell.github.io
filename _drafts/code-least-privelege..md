---
layout: post
title:  "Code with the Least Privilege"
date:   2015-11-16 22:37:07
tags: code ideas minimalist
---

There is a principle in computer science called the Principle of Least
Privilege. It is a recommended security practice for
giving any process, user or program the least access possible. I think this
idea should also be applied to your code. You should **restrict your code as
much as possible.**

The idea behind the standard Principle of Least Privilege is straight forward
and typically applied to security. The wider the surface area of any system the
more hackers can attack. By using the lowest permissions possible
for any user, process, server or service what could be lost or stolen when a
system is compromised is reduced.

Great. We can also apply the idea to code. Restrict what? The visibility
between classes/assemblies to intentionally define a smaller public API.

You should be very intentional with what you make public. Anything you make
public will need to be supported and maintained. Once made public removing or
changing an API is harder. There is more to maintain and changes which would
otherwise be private could cause breaking changes.

For this reason I favour minimalist APIs. Everything not public can be more easily
refactored and improved. By keeping as much code as you can private/internal you
shrink public API's surface area.

In this post I am going to go show how to use the keywords in C# to restrict
your code and help you intentionally craft your APIs. While you can apply the
same ideas to external APIs, I will focus on backend code here. The following
examples are inspired by our code to highlight different techniques we use
to achieve the exact code behaviour and visibility we want.

A simple example: A Factory
===============================================================================

Lets try a simple example. If you have a factory class the class being created
can be made internal instead of public. Here is what you do NOT want to do:

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
start calling the class directly which would make the factory unnecessary. With
other using the original class directly changing the constructor, dependencies
or class being created are all breaking changes.

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

We had worker classes for processing queued work and then send callbacks
indicating the work is done or failed. Within the class there was a handy
method for sending callbacks. The helpers method would format the callback url
and other parameters then use other classes for actually sending the callback.

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

The sample above shares too much. Why would ``SendCallback`` be public? It
doesn't fit with ``Worker``'s purpose of processing work items. The method is
only used within the class and is nicely isolated within ``Worker``. Since
we would never want other classes using the method it should be private!

{% highlight csharp %}
public class Worker {
    private void SendCallback( Uri url ) { ... }
}
{% endhighlight %}

Much better. Had we left this method public it could accidentally be used.
Keeping it private allows it to continue to evolve separate from the API of
``Worker``.

Sounds good right? There is a catch, testing these methods is harder. You can't
test them directly because they are now private. Instead you need to test them
indirectly through the inputs/outputs of other methods or their behaviours.
If the logic is really complicated you might want to pull it out into separate
classes and interfaces.

In the example above we have separated sending the callback into a
different class. This lets us test the Worker and sending callbacks separately.
The logic for sending callbacks is consolidated in the dedicated class.
The private method in ``Worker`` is still useful
and allows us to prepare the ``Payload`` to be sent. The resulting helper classes look
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

We intentionally keep these helper classes internal. While they are useful on their own,
they have been created just for use within this assembly. Right now we don't think
anyone else would want to send their callbacks the same way. Due to this we have
left them out of the public API until we are proven otherwise.

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

{% highlight csharp %}
// T is both an Exception and has a default constructor
public class ExceptionThrower<T> where T: Exception, new() {}

// Using generics to keep callers type safe
public static class Cloner {
    public static IEnumerable<T> For<T>( T original, int n )
        where T : ICloneable {

        for( int i = 0; i < n; i++ ) {
            yield return (T)original.Clone();
        }
    }
}

// Fun with generics to create type safe factories
public interface IFactory<T> where T : class {
    T Create();
}

public class DefaultFactory<T> : IFactory<T> where T: class, new() {
    public T Create() {
        return new T();
    }
}
{% endhighlight %}

Conclusion
===============================================================================

Minimize API. Use the language to your advantage to do exactly what you want.

Everything should be private/internal.
Be very intentional about what is made public.

Minimalist APIs

I decided to move this to the footer. I have been known to commit generics
abuse in the past. Here is some fun code which uses constraints against
multiple types to enforce a strongly typed API. Within the class the types
are relaxed a bit so they can all play together.

I would discourage you from ever using a class like this. Use a DI container
like [Autofac][autofac] instead.

{% highlight csharp %}
public class FactoryCollection {
    private readonly Dictionary<Type, object> m_factories =
        new Dictionary<Type, object>();

    public void Add<TDependencyType, TFactoryType>( TFactoryType factory )
        where TDependencyType : class
        where TFactoryType : IFactory<TDependencyType> {

        m_factories[typeof(TDependencyType)] = factory;
    }

    public void Add<TDependencyType, TFactoryType>( TFactoryType factory )
        where TDependencyType : class
        where TFactoryType : IFactory<TDependencyType>, new() {

        Add<TDependencyType, TFactoryType>( new TFactoryType() );
    }

    public void Add<TDependencyType>()
        where TDependencyType : class, new() {

        Add<TDependencyType, DefaultFactory<TDependencyType>>(
            new DefaultFactory<TDependencyType>()
        );
    }

    public bool TryCreate<TDependencyType>( out TDependencyType result )
        where TDependencyType : class {

        Type type = typeof(TDependencyType);
        if( !m_factories.ContainsKey( type ) ) {
            result = default( TDependencyType );
            return false;
        }

        IFactory<TDependencyType> factory = (IFactory<TDependencyType>)m_factories[type];
        result = factory.Create();
        return true;
    }
}
{% endhighlight %}

[templates]: https://sourcemaking.com/design_patterns/template_method
[coi]: https://en.wikipedia.org/wiki/Composition_over_inheritance
[generics]: https://msdn.microsoft.com/en-us/library/d5x73970.aspx
[autofac]: http://autofac.org/
