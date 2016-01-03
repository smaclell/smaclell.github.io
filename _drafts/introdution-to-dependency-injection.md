---
layout: post
title:  "Introduction to Dependency Injection"
description: "The nuts and bolts of Dependency Injection. Everything you need to know plus how it compares against other patterns like a Factory."
date:   2015-12-30 23:45:07
tags: dependency-injection
---

TODO: Image of a book

I have had the privlege of mentoring several co-workers this year. Without fail
on of the topics which they find confusing is Dependency Injection. Have no fear.
At its core it is a powerful tool that conceptually is much simpler.

Let's start with some really simple classes:

{% highlight csharp %}
public class Foo {
    public void Hello( string message ) {
        Console.WriteLine( "Hello {0}", message );
    }
}

public class Bar {
    Foo m_foo;

    public Bar() {
        m_foo = new Foo();
    }

    public void Example() {
        m_foo.Hello( "World" );
    }
}
{% endhighlight %}

These are all concrete classes. No fancy dependency injection or inversion
here. What this code does is very clear. ``Bar`` creates a ``Foo`` then
uses it to print ``Hello World``.

Dependency Inversion Principle Applied
===============================================================================

Let's spice things up! Instead of using creating the ``Foo`` in ``Bar``'s
constructor we can pass it in. Better yet, we can switch to an interface with
all the same methods as ``Foo``.

{% highlight csharp %}
public interface IFoo {
    void Hello( string message );
}

public class Foo : IFoo {
    public void Hello( string message ) {
        Console.WriteLine( "Hello {0}", message );
    }
}

public class Bar {
    IFoo m_foo;

    public Bar( IFoo foo ) {
        m_foo = foo;
    }

    public void Example() {
        m_foo.Hello( "World" );
    }
}
{% endhighlight %}

So what have we gained? Well, the low level ``Bar`` class no longer knows
anything about the ``IFoo`` implementation it is using. That is now up to the
caller. We have switched from a concrete implementation to a higher level
abstraction.

This is applying the Dependency Inversion Principle which is different from
Dependency Injection. The [principle's definition][dip]<a href="#di-note-1"><sup id="reverse-di-note-1">1</sup></a> is attributed to
[Robert Martin][bob] as follows:

> A. High level modules should not depend upon low level modules. Both should depend upon abstractions.
>
> B. Abstractions should not depend upon details. Details should depend upon abstractions.

[The abstraction could be anything][di-abstraction]. Typically it will be an
interface, but can also be a base class, delegate or other abstraction. The key
is shifting the code from the implementation to a higher level.

What About Dependency Injection?
===============================================================================

Another concept that is often lumped in the Dependency Inversion is Depdendency
Injection. Don't worry. It is at the core it is a really simple idea.

Here is the demysified version by [James Shore][james]:

> Dependency injection means giving an object its instance variables.

Literally injecting dependencies into a class. In our example we used
parameters to the constructor, but you could you could also use properties or
specialized methods. Look at the constructor in the example again:

{% highlight csharp %}
public class Bar {
    IFoo m_foo;

    // --> Boom, injected
    public Bar( IFoo foo ) {
        m_foo = foo;
    }

    public void Example() {
        m_foo.Hello( "World" );
    }
}
{% endhighlight %}

The ``IFoo`` is injected into the constructor by whatever code is using the
``Bar`` class.

Dependencies For Everyone!
===============================================================================

Combining Dependency Inversion with Dependency Injection and you have classes
with all their dependencies met. You can easily change what they depend on for
testing or to compose your code differently.

We have one little problem. Now every class applying both ideas is harder to
create. The caller needs to decide how to create the object. We have moved the
choice for how the object is created making it harder for every other class.

This can really REALLY get out of hand. You can quickly get to large chains of
dependencies which need to bet put together. One class has a dependency, the
dependency has more dependencies, those dependencies have even more dependencies.
This is the tip of the iceberg:

{% highlight csharp %}
SqlConnection connection = new SqlConnection( "connection string" );

FooRepository repository = new FooRepository( connection );

Logger logger = new ConsoleLogger();

BarService controller = new BarService( repository, logger );
{% endhighlight %}

If every class repeated this setup it would be a big problem. Creating anything
would be a nightmare. Thankfully there are better solutions.

Enter the Factories
===============================================================================

With all this injection madness we need to find a better way to abstract how
classes are created.  Before we go deeper try to simplify using Dependency
Injection lets take a pitstop at the most basic creational pattern: A Factory.

With the Factory we will create a simple class responsible for creating a
concrete ``IFoo``. It can be used any time an ``IFoo`` is needed without any
knowledge of the real ``IFoo``. For this example, we can rely on the
``FooFactory`` instead of directly creating either ``ConsoleFoo`` or ``FileFoo``.

{% highlight csharp %}
public class FooFactory {
    public IFoo Create() {
        return new ConsoleFoo();
    }
}

public interface IFoo {
    void Hello( string message );
}

internal class ConsoleFoo : IFoo {
    public void Hello( string message ) {
        Console.WriteLine( "Hello {0}", message );
    }
}

internal class FileFoo : IFoo {
    public void Hello( string message ) {
        File.AppendAllText( "C:\\foo.txt", "Hola " + message );
    }
}

public class Bar {
    IFoo m_foo;

    public Bar( IFoo foo ) {
        m_foo = foo;
    }

    public void Example() {
        m_foo.Hello( "World" );
    }
}
{% endhighlight %}

This can contains the sprawling dependencies, but leads to many small lightly
used classes. Everytime a ``IFoo`` is needed we need to recreate the factory.
If there are many factories the factories themselves can become pretty
complicated with lots of factories calling factories.

This is a little better. There is still a bunch of glue code for wiring all
the dependencies together. I think we can do better.

Poor Man's Dependency Injection Container
===============================================================================

I think we can do better than all the write up caused by the original code and
the Factory. What if we could use a single class to get any dependency we
wanted? Think of an ``IDictionary`` which could return an instance of any class
it knows how to create.

In many ways this the core functionality most Dependency Injection Containers
provide. Before we go to the real thing I wanted to explore the simple dictionary
version.



Show the dictionary of types. I can now get instances of classes, but it is aweful.
Don't do this at home. Show the concept.

Complete Dependency Injection FTW
===============================================================================

Talk about libraries, splitting providing dependencies and consuming them.
This scales great even for really large applications.

Downside is following how the code fits together is really hard. Troubleshooting
can be harder.

<hr />

<a href="#reverse-di-note-1"><span id="di-note-1">1.</span></a> I could not get this link to work. I found it
via [this][di-abstraction] great article explainning how an abstraction is not synonymous with interfaces.

<hr />

**Thanks to my gracious 2015 mentees for letting me practice this on you.**

[dip]: http://www.objectmentor.com/resources/articles/dip.pdf
[bob]: https://twitter.com/unclebobmartin
[di-abstraction]: https://lostechies.com/derickbailey/2008/10/20/dependency-inversion-abstraction-does-not-mean-interface/
[james]: http://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html
