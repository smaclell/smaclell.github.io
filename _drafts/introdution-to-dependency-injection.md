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
caller.

This is applying the Dependency Inversion Principle which is different from
Dependency Injection.

TODO: Link and full definition.

Enter the Factories
===============================================================================

Show the factory method
Show a factory class

Dependencies For Everyone!
===============================================================================

Show a billion dependencies getting out of hand

Poor Man's Dependency Injection
===============================================================================

Show the dictionary of types. I can now get instances of classes, but it is aweful.
Don't do this at home. Show the concept.

Complete Dependency Injection FTW
===============================================================================

Talk about libraries, splitting providing dependencies and consuming them.
This scales great even for really large applications.

Downside is following how the code fits together is really hard. Troubleshooting
can be harder.

**Thanks to my gracious 2015 mentees for letting me practice this on you.**