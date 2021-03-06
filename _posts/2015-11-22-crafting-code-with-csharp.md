---
layout: post
title:  "Crafting Code with C#"
date:   2015-11-22 23:42:07
description: "Using C# keywords to restrict code to achieve the exact API you want."
tags: code ideas minimalist
image:
  feature: https://farm9.staticflickr.com/8318/8064389346_891cf17296_c.jpg
  credit: "Ickworth Wood & Craft Fair by Dave Catchpole - CC BY 2.0"
  creditlink: https://www.flickr.com/photos/yaketyyakyak/8064389346/
---

In this post. I am going to go show how to use the keywords in C# to restrict
your code and help you intentionally craft your APIs. While you can apply the
same ideas to external APIs, I will focus on backend C# code here. The following
examples are inspired by our code to highlight different techniques we use
to achieve the exact code behaviour and visibility we want.

A simple example: A Factory
===============================================================================

Let's try a simple example. If you have a factory class the class being created
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
other classes directly using ``CoolWidget`` changing the constructor, dependencies
or creating a different class in the factory are all breaking changes.

Instead, ``CoolWidget`` should be internal! Much better. The factory cannot be
bypassed.

{% highlight csharp %}
internal class CoolWidget : IWidget {
    ...
}
{% endhighlight %}

Hide Internals: A Worker Class
===============================================================================

Doing work in classes can get complicated. I looked through a whole bunch of
our code and found we often use private methods for doing little bits of work.

We have worker classes for processing queued work which then send callbacks
indicating the work is done or has failed. Within the class, there was a handy
method for sending callbacks. The helper method would format the callback URL
and other parameters then use other classes to actually send the callback.

{% highlight csharp %}
public class Worker {
    public void Process( WorkItem work ) {
        ...
        SendCallback( work.CallbackUrl )
    }

    public void SendCallback( Uri url ) { ... }
}
{% endhighlight %}

The sample above shares too much. Why would ``SendCallback`` be public? It
doesn't fit with ``Worker``'s purpose: processing work items. The method is
only used by ``Worker`` and is nicely isolated to the class. Since
we would never want other classes using the method, it should be private!

{% highlight csharp %}
public class Worker {
    private void SendCallback( Uri url ) { ... }
}
{% endhighlight %}

Much better. Had we left this method public it could accidentally be used.
Keeping it private allows it to continue to evolve separately from the API of
``Worker``.

Sounds good, right? There is a catch, testing these methods is harder. You can't
test them as easily because they are now private. Instead, you need to test them
indirectly through the inputs/outputs of other methods or using their behaviours.
If the logic is really complicated you might want to move it into separate
classes and interfaces.

In the example above we have separated sending the callback into a
different class. This lets us test the ``Worker`` and sending callbacks separately.
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

This lets us keep the logic testable and the external API small. There
are now more classes which might make the code more complicated.

We intentionally keep these helper classes internal. While they are useful on their own,
they have been created for use only within this assembly. Right now we don't think
anyone else would want to send their callbacks the same way. Due to this we have
left them out of the public API until we are proven otherwise.

Inheritance: Family Planning
===============================================================================

Controlling inheritance is useful. Most developers I work with avoid using it
like the plague due to issues they had in the past. [Composition over inheritance][coi]
is not only recommended, it is enforced by marking most classes as ``sealed``:

{% highlight csharp %}
public sealed class CantTouchThis { ... }
{% endhighlight %}

Marking classes as ``sealed`` prevent the class from being inherited. This
stops inheritance abuse. To be honest, I think it is overkill since there
are very few cases where you need to explicitly block inheritance. More often
than not you don't have to worry about it. People don't willy nilly start
inheriting from classes when none of the methods can be overridden and there
are no protected fields.

Inheritance: Template Class
===============================================================================

I think base classes can be useful when used correctly. I use them to setup [template methods][templates]
or share common/optional functionality. This isn't a technique I use too often.
I like to treat it as yet another code design tool.

To enforce the purpose you envisioned for your base classes, I recommend using
``abstract`` classes and methods. This keyword ensures your desired methods must be
implemented by child classes. The base class itself cannot be instantiated
which further clarifies its purpose as a base class.

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
Classes inheriting from ``TaxesCalculatorBase`` must implement
the required methods and can do so however they like. To prevent the hierarchy from
growing out of hand, you can optionally mark the child classes as ``sealed``.

Another usage of base classes is implementing common or optional functions. I used
this recently to make optionally implementing part of an API easier. The class
had a method to return an ``IEnumerable``. The default implementation in the
base class returns an empty list. When the team was ready we could update the
child classes one at a time to provide the new functionality.

{% highlight csharp %}
public abstract class ExampleProviderBase {
    public virtual IEnumerable<IExample> GetExamples() {
        return Enumerable.Empty<IExample>();
    }
}
{% endhighlight %}

All Action: Helper Classes
===============================================================================

Every now and then we have helper classes with only methods and no state.
Stateless classes can be made ``static`` to prevent them
from being instantiated or having instance variables added. If you had a
helper classes for ``Uri``'s it might look like this:

{% highlight csharp %}
internal static class UrlHelpers {
    public static Uri FormatUri( Uri baseUrl, string route ) { ... }

    public static Uri TruncateUri( Uri baseUrl ) { ... }

    public static Uri SomethingCoolWithAUri( Uri baseUrl ) { ... }
}
{% endhighlight %}

The ``static`` constraint helps the class stay stateless and cannot be instantiated. Having the class be
``static`` ensures all the methods must also be declared as ``static``.

Manage state: Immutable Classes
===============================================================================

I think it is worth the minor effort to control whether fields/properties can
be modified. Limiting the number of ways data can be modified and passed around
can help highlight the right way to use your classes. The extreme version of
this are immutable classes which cannot have their values changed and must be
fully initialized when they are created.

In this simple example, I have made a ``Person`` class which is immutable. There
would be other classes for retrieving and updating the data. Anyone trying to
create a ``Person`` must provide the necessary value at creation time. This is
a great opportunity to validate any inputs to prevent invalid objects from being
created.

{% highlight csharp %}
internal sealed class Person {
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
``readonly`` to force the fields to be initialized inside the constructor.
This allows the compiler to enforce keeping the class immutable.

{% highlight csharp %}
internal sealed class Person {
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

In [C# 6][cs] ``readonly`` fields become even easier thanks to getter only properties.
This is the same as the first example except for the missing ``private set`` on the
properties. Like the second example, the compiler will again ensure the properites are
not modified outside the constructor.

{% highlight csharp %}
internal sealed class Person {
    public string FirstName { get; }
    public string LastName { get; }

    public Person( string first, string last ) {
        FirstName = first;
        LastName = last;
    }
}
{% endhighlight %}

Another great immutability technique is to create a new object with every
operation which would otherwise modify the current object. Great examples of this
approach are the ``DateTime`` and ``string`` classes:

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

Immutable classes strongly affect how users interact with them. They can
reinforce readonly parts your API and highlight how you want data to be updated.

Generics: A Different Animal
===============================================================================

Generics are an extremely powerful way to stay flexible while remaining strongly typed.
Adding constraints to generic parameters, ensure the types used with your class
match your expectations. If nothing else I find the constraints are a
[fun](#generics-fun) way to strictly enforce strong typing.

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

I hope you enjoyed these examples showcasing the C# keywords and how you can
use them to create the exact API you want. I believe it is important to
intentionally limit the surface area of your API by restricting how your
classes can be used and the properties/methods they expose. Carefully crafting
your API should make future maintenance easier.

<hr />

<strong id="generics-fun">Fun with Generics</strong>

I decided to move this to the footer. I have been known to abuse generics
in the past. Here is some fun code which has constraints against
multiple types. This ensures stronger types throughout the API. Within the class, less
restrictive types are used to avoid needing a common interface for the inputs.

I would discourage using this particular class in your code. Use a DI container
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
[cs]: https://github.com/dotnet/roslyn/wiki/New-Language-Features-in-C%23-6
[generics]: https://msdn.microsoft.com/en-us/library/d5x73970.aspx
[autofac]: http://autofac.org/
