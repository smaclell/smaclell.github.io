---
layout: post
title:  "Introduction to Dependency Injection"
description: "Dependency Inversion with out all the magic. Review the basics and learn simple models of Dependency Injection Containers."
date:   2016-01-08 23:45:07
tags: dependency-injection dependency-inversion introduction basics Autofac StructureMap Nancyfx TinyIoc
image:
  feature: https://farm6.staticflickr.com/5269/5610940978_1195ce9cff_b.jpg
  credit: "The Wizard of Oz 0778 by Mraz Center - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/theatrebhs/5610940978/
---

I had the privilege of mentoring several co-workers in 2015. One of the
topics they found confusing was Dependency Injection. We use it everywhere. To
them it felt like magic. The code just fits together through mystical Containers.
Have no fear. In this post we will break down the powerful concepts surrounding
Dependency Injection.

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
anything about the ``IFoo`` implementation it is using. That is now up to
callers using ``Bar``. We have switched from a concrete implementation to a higher level
abstraction.

We have applied the [Dependency Inversion Principle][dip]<a href="#di-note-1"><sup id="reverse-di-note-1">1</sup></a>.
As defined by [Robert Martin][bob] it is:

> A. High level modules should not depend upon low level modules. Both should depend upon abstractions.
>
> B. Abstractions should not depend upon details. Details should depend upon abstractions.

[The abstraction could be anything][di-abstraction]. Typically it will be an
interface, but can also be a base class, delegate or other abstraction. The key
is shifting the code from the implementation to a higher level.

What About Dependency Injection?
===============================================================================

Another concept closely related to Dependency Inversion is Dependency Injection.
In fact, we used it without really knowing it. Where Dependency Inversion was
all about the abstractions and layers, Dependency Injection is all about how
dependencies are provided.

Don't worry. At it is a really simple idea. Here is the demystified version by [James Shore][james]:

> Dependency injection means giving an object its instance variables.

Literally, injecting dependencies into a class. In our previous example, we 
injected our dependencies using parameters on the constructor,
but you could also use properties or specialized methods.

Look at the constructor from the example again:

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

Injecting Inverted Dependencies
===============================================================================

Until this point we have inverted our dependencies so we could inject them
into our classes. This is fantastic! Our code is nicely decoupled. We can
easily change what is injected for testing, introducing new features or to
compose your code differently.

Implementations are hidden
behind abstractions and can be easily replaced. Want an ``IFoo`` which writes
out to files? No problem. You can change the code to use it without ever
modifying ``Bar``.

The original implementation would be hard to test ``Bar`` in isolation due to
the concrete classes. We could now fake ``IFoo`` in the test to do whatever
we want. This is a great way to set up specific scenarios and/or avoid external
systems (i.e. databases or services).

Dependencies For Everyone!
===============================================================================

We have one little problem. When every class applies both ideas, creating
anything is really hard. The choice for what to inject into our inverted classes
has been moved to their callers. Choosing what concrete implementations to use
is unclear.

This can really REALLY get out of hand. You can quickly have large dependency
chains which don't mesh together easily. One class has a dependency, the
dependency has more dependencies and those dependencies have their own dependencies.
You can see how this might spiral out of control. This is the tip of the iceberg:

{% highlight csharp %}
SqlConnection connection = new SqlConnection( "connection string" );

FooRepository repository = new FooRepository( connection );

Logger logger = new ConsoleLogger();

BarService controller = new BarService( repository, logger );
{% endhighlight %}

If every class repeated this setup it would be a big problem. Creating anything
would be a nightmare. Thankfully there are better solutions.

(Dependency Injection) Containers
===============================================================================

With all this injection madness we need to find a better way to create classes.
Don't worry! There are fantastic libraries to help address
this problem. These are commonly referred to as Dependency Injection Containers
because they contain and seamlessly connect all of your dependencies.

Before we get to the real thing I want to walk you through 3 simple mental
models for how the Containers behave. The real Containers are still a little
complicated. Conceptually they are a little bit like:

* A Factory
* A Dictionary for types

### Enter the Factories

A Factory is a really simple creational pattern. They allow you to abstract
what is being created and how it is created. Dependency Injection Containers
behave like Super Factories which can create any type they know about.

Want an ``IFoo``? Use the ``FooFactory``!

{% highlight csharp %}
public class FooFactory {
    public IFoo Create() {
        return new ConsoleFoo();
    }
}

internal class ConsoleFoo : IFoo {
    public void Hello( string message ) {
        Console.WriteLine( "Hello {0}", message );
    }
}
{% endhighlight %}

It can be used any time an ``IFoo`` is needed without any knowledge of which ``IFoo`` is created.
We could easily update the ``FooFactory`` to create a ``FileFoo``.

{% highlight csharp %}
public class FooFactory {
    public IFoo Create() {
        return new FileFoo();
    }
}

internal class FileFoo : IFoo {
    public void Hello( string message ) {
        File.AppendAllText( "C:\\foo.txt", "Hola " + message );
    }
}
{% endhighlight %}

This can partially contain the sprawling dependencies. There will be many
factories and often factories will need to call factories. This can get
complicated when many dependencies are needed. The extra classes and glue code
is tedious to maintain.

Prior to using ``IFoo`` we still need to create one using the factory:

{% highlight csharp linenos %}
public class Program {
    static void Main() {
        FooFactory factory = new FooFactory();
        IFoo foo = factory.Create();

        Bar bar = new Bar( foo );

        bar.Example();
    }
}
{% endhighlight %}

We can do better.

### Poor Man's Dependency Injection Container

What if we could use a single class to get any dependency we wanted?
Instead of a Factory, we could have a Dictionary keyed on types where the
values define how to create any class. We could then create any class the
Dictionary knows about.

In this section, we are going to create a really simple class to do just
that. Our very own simple Dependency Injection Container.

Why is it called a Container? It will contain all our application's dependencies.
When our application starts we will give it all the dependencies we want to
create and classes we want to inject the dependencies into.

The Container needs to:

1. Resolve dependencies our application needs
2. Register dependencies our application provides

Enough with the words! First one little hiccup, our Container needs to know how
to create any dependency. For now let's avoid that problem and use a simple
``Func<T>`` like a Factory. Okay, onto the code!

{% highlight csharp %}
public interface ISimpleContainer {
    public T Resolve<T>();

    public void Register<T>( Func<T> factory );
}
{% endhighlight %}

Not bad. One method to Register dependencies and another to Resolve
them. This pair of methods makes the entire Container behave like a fancy
Dictionary. Let's implement our simple version:

{% highlight csharp %}
public class SimpleContainer : ISimpleContainer {
    private readonly Dictionary<Type, Delegate> m_registrations =
        new Dictionary<Type, Delegate>();

    public T Resolve<T>() {
        Func<T> factory = (Func<T>)m_registrations[typeof(T)];
        return factory();
    }

    public void Register<T>( Func<T> factory ) {
        m_registrations.Add( typeof(T), factory );
    }
}
{% endhighlight %}

Using the Container is easy. In the next example, we register all the types (lines 5-11)
then resolve them (lines 8 and 13). Once we have resolved ``Bar`` we can use it normally!

{% highlight csharp linenos %}
public class Program {
    static void Main() {
        SimpleContainer container = new SimpleContainer();

        container.Register<IFoo>( () => new ConsoleFoo() );
        container.Register<Bar>(
            () => {
                IFoo foo = container.Resolve<IFoo>();
                return new Bar( foo );
            }
        );

        Bar bar = container.Resolve<Bar>();

        bar.Example();
    }
}
{% endhighlight %}

Cool we have a Container. It is awkward to use though. I would not use it in a
real project. Again we had to wire everything together on our own. We had to
tell it exactly how to create a ``Bar`` even though it already knew how to
create an ``IFoo``.

This is where real Dependency Injection Containers are fantastic. They solve
this wiring problem and automatically inject dependencies they know about. I
might not need to register ``Bar`` at all.

We replaced using Factories with calls to the Container. The individual classes
don't need to know how they are created. That logic can live within the
Container. We can now use the Container as glue to binds everything together.

Abstractions are registered as concrete types. Consumers can resolve and use
those abstractions directly. They have no knowledge of the concrete types being
used. Instead they rely on the Container. This preserves the Dependency
Inversion principle and helps decouple our code.

We don't have to do any better than this Container. We can use any of the
existing open source Dependency Injection Containers.

### Awesome Containers

Thankfully, there are many great open source Dependency Injection Containers.
The following three are my favourites. We have used each of them on different projects.

**[Autofac][autofac]**

Autofac is new, super clean, powerful and generally just nice. The registration
API is fantastic! They have an interesting separation between registered items
and the dependencies which can be resolved. They also have great support for
controlling [lifetimes/scoping][auto-life] and [cleaning up for you][auto-dispose]. This would be my
first choice if starting a new application using ASP.NET MVC.

**[StructureMap][structuremap]**

StructureMap is battle hardened having been the original .NET Dependency Injection
Container. The latest version of StructureMap was a massive step forward with
learning from the 10 years supporting the project. A great choice, I highly
recommend checking it out.

**[TinyIoC][tinyioc] via [Nancy][nancyfx]**

Lastly, we use Nancy a lot! For the simpler applications, we take advantage of the
built-in TinyIoC. It is simpler than the other Containers. So far we have been
able to use it exclusively in our applications. As our services get bigger it is
starting to not work as well. We have needed to complicate our configuration since
more advanced features are not included. As a result, we periodically consider
switching to one of the other libraries.

### More Out of the Box

These libraries greatly enhance how you can register and resolve components.
Often these capabilities are connected; features used
when registering influence how objects are resolved.

They can all wire together classes based on their dependencies. You could
register ``Bar`` and when it is resolved the Container would automatically
inject an ``IFoo`` based on what was registered.

{% highlight csharp linenos %}
using System;
using Autofac;

public class Program {
    static void Main() {
        ContainerBuilder builder = new ContainerBuilder();

        builder.RegisterType<ConsoleFoo>().As<IFoo>();
        builder.RegisterType<Bar>().AsSelf();

        IContainer container = builder.Build();

        Bar bar = container.Resolve<Bar>();

        bar.Example();
    }
}
{% endhighlight %}

Many have shortcuts for simple transformations, i.e. from ``T`` to ``Lazy<T>``.
Often they can support resolving/registering generic types.

They offer the ability to register sets of dependencies in
[Modules][auto-modules] or [Registries][sm-registry]. This provides a simple
way to group registrations together or split them apart. For example, you could
register all database related classes in one module separate from your logging
configuration.

Most provide mechanisms
for registering your types based on conventions so you do not
need to configure everything by hand. For example register all interface
implementations similar to the interface name, ``Example`` would be registered
for ``IExample``.

Perhaps the greatest benefit is simplified integration with various frameworks.
They have shortcuts to hook into popular web frameworks, like ASP.NET MVC or
Nancy, so the framework can resolve types they need. We use this to create
Controllers and inject any dependencies they need. This lets you use Dependency
Injection while decoupling your code from the Container. Everything
fits together as if by magic.

The larger our applications get the better these frameworks are. We no longer
worry about how we are going to wire our classes together. Instead, we can
concentrate on designing our interfaces and classes so we can solve problems.

Connecting the Dots
===============================================================================

Phew, you made it this far! I hope this helped shed some light on Dependency
Injection and the surrounding concepts.

Instead of using concrete classes we switched to higher level dependencies,
applying Dependency Inversion. We needed to get those dependencies from
somewhere so we used Dependency Injection, via the constructor, to inject the
dependencies we wanted.

We looked at two simple mental models for Dependency Injection  Container:

* A Factory
* A Dictionary for types

Then we dug into real Dependency Injection Containers and some of their
advanced features.

Have fun decoupling your dependencies!

<hr />

### Further Reading

This is just scratching the tip of the
iceberg. There is so much more you can read and learn. While writing this post
here are some great resources I found:

**[Autofac][auto-docs] and [StructureMap][sm-docs] Documentation**

Both these libraries are fantastic and their maintainers have put some serious
work into writing comprehensive documentation. They share many recommendations
and pitfalls for using their frameworks. The most interesting is insights into
decisions they made and why they made them.


**[Container Guidelines][guidelines]**

Dependency Injection Containers can be extremely impactful to how you design
your application. They do need to be treated with some care. Jimmy has a
number of great recommendations<a href="#di-note-2"><sup id="reverse-di-note-2">2</sup></a> to keep your application clean and stay out
of the weeds.

**[DIP in the Wild][wild]**

Real life applications of Dependency Injection in the wild plus a good recap of
the concepts I introduced here. Good discussions about abstractions they added
to their application and how the concepts apply. WARNING: It is pretty big.

**[Inversion of Control Containers and the Dependency Injection pattern][injection]**

This is a more in-depth explanation of the concepts. They also go into the
closely related idea of "Inversion of Control" and "Service Locators".
Again there is a good review of best practices and trade-offs from different
approaches. WARNING: It is pretty big.

<hr />

### Footnotes

<a href="#reverse-di-note-1"><span id="di-note-1">1.</span></a> I could not get this link to work. I found it
via [this][di-abstraction] great article explaining how an abstraction is not synonymous with interfaces.

<a href="#reverse-di-note-2"><span id="di-note-2">2.</span></a> For some applications we intentionally call
the container from our tests. We treat the Container configuration as part of our integration tests. I will
agree this is not ideal, but it simplifies creating various types and better mimics our users.

<hr />

### Thanks

*Thanks to my gracious 2015 mentees for letting me practice this on you.*

*Thanks again to my co-worker Josh who helped review this article. He had the
great recommendation of renaming the "Poor Man's DI Container section" to
"Man with too much time on his hands' DI Container". Maybe I need to go write
more code.*

[dip]: http://www.objectmentor.com/resources/articles/dip.pdf
[bob]: https://twitter.com/unclebobmartin
[di-abstraction]: https://lostechies.com/derickbailey/2008/10/20/dependency-inversion-abstraction-does-not-mean-interface/
[james]: http://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html
[autofac]: http://autofac.org/
[auto-life]: http://autofac.readthedocs.org/en/latest/lifetime/index.html
[auto-dispose]: http://autofac.readthedocs.org/en/latest/lifetime/disposal.html
[structuremap]: http://structuremap.github.io/
[tinyioc]: https://github.com/grumpydev/TinyIoC/wiki
[nancyfx]: http://nancyfx.org/
[auto-modules]: http://autofac.readthedocs.org/en/latest/configuration/modules.html
[sm-registry]: http://structuremap.github.io/registration/
[auto-docs]: http://autofac.readthedocs.org/en/latest/index.html
[sm-docs]: http://structuremap.github.io/documentation/
[guidelines]: https://lostechies.com/jimmybogard/2008/09/12/some-ioc-container-guidelines/
[wild]: http://martinfowler.com/articles/dipInTheWild.html
[injection]: http://www.martinfowler.com/articles/injection.html