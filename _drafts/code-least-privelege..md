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
like the plague due to issues they had in the past. Composition over
inheritence is not only recommended, it is enforced by marking most classes as
``sealed``:

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

Every now and then there are ``Helper`` classes with nothing, but simple
functions to make life easier. It is useful to mark these classes as ``static``
to prevent them from being instantiated. Having the class be ``static`` ensures
all the methods must also be declared as ``static``. You might use it for a
helper class like this one:

{% highlight csharp %}
internal static class UrlHelpers {
    public static Uri FormatUri( Uri baseUrl, string route ) {
        ...
    }

    public static Uri TruncateUri( Uri baseUrl ) {
        ...
    }

    public static Uri SomethingWithAUri( Uri baseUrl ) {
        ...
    }
}
{% endhighlight %}

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

The Basics: Classes
===============================================================================

Here is the story of two classes. One is very open and could easily by used in
ways you would not want. The second is locked down so it can only be used in
the way it was intended. The goal is to streamline the API provided by your
classes and assemblies.

// TODO: Travis recommended writing side by side example then breaking them down.
{% highlight csharp %}
public class CsvCalculator {
    public int Process( string filePath ) { ... }
    public int Add( IEnumeable<int> values ) { ... }
}
{% endhighlight %}

Classes tend to be a bit chunkier. They provide larger entry points to the
concrete behaviour your library or project provides.

Luckily in C# they control over classes is pretty simple. 

* Expose a class using ``public``
* Hide a class within an assembly using ``internal``
* Force inheritance to implement methods using ``abstract``
* Prevent all inheritance using ``sealed``
* Break up declaring a class into separate files using ``partial``
* Create utility classes using ``static``

At two ends of a very narrow spectrum are ``public`` and ``internal``. You want
almost all your classes to be ``internal`` and only a few exposed using
``public``.

The next modifiers ``abstract`` and ``sealed`` are great for controlling how
and if your classes are inherited. Both modifiers are very powerful and define
how classes can be used.

Using ``abstract`` classes with abstract methods force
consumers to implement your base classes. This can be great for [Template Methods/Classes][TODO]
for laying out how you want the class to be used.

After having inheritance
abused for too long we have started to use ``sealed`` heavily. If this is not a
problem for you I would not both including it. However, it allow you
intentionally force composition over inheritance by preventing classes from
being extended unless you want them too be.

The next modifier ``partial`` is nice to break up larger classes or isolate
generated code. It is reasonable to say if you want to use ``partial`` to break
up large classes it is a code smell. However, it is commonly used to split
generated code from your code. If you are generating you code code, try it out.

Marking utility classes as ``static`` is fantastic. They can never be
instantiated and cannot have normal class variables. Every method and field
must be declared as ``static``. Great for helper classes
which contain methods or does not need to save any state within the class. In
order to create extension methods your class must be static.

Deeper Inside Classes
===============================================================================

Within classes there is a great deal which can be done to modify visibility.
Fields and methods can be modified so they are more or less exposed.

private
protected
internal
internal protected ;)
public

abstract
virtual

Like utility classes, ``static`` can be used to define class level methods or
fields. Small helper methods 

Two modifiers in order to prevent fields from being written or updated are
``const`` and ``readonly``. ``const`` can only be used with types which can
be constants at compile time and cannot be modified at all. This works great
with primitive types. ``readonly`` types can have other modifiers applied and
can only be set when the object is being constructed. More complex types can be
created using ``readonly`` and how they are built is up to you.

Advanced Techniques Beyond Classes
===============================================================================

#### Immutability

Allowing data you pass around to be created and never modified

immutabable classes (get, but no set)
what about tests? The exception I would make to this is allowing test classes to access internal classes.
As little as you can in web API's
Consider the future, wait until then to act on it.
namespaces

Conclusion

Minimize API. Use the language to your advantage to do exactly what you want.

Notes
-------------------------------------------------------------------------------

Everything should be private/internal.
Be very intentional about what is made public.

Minimalist APIs

Small the surface area the fewer places classes can break each other.
Increases the attention on fewer places.

Few public classes intentionally exposed which define the API. Everything not exposed is free to evolve whereas the API is not.
Fewer places to carefully version and update.

Don't leave data open for whatif scenarios. Expose it when you need it. YAGNI.

[templates]: https://sourcemaking.com/design_patterns/template_method
