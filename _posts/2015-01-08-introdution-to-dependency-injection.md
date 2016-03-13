---
layout: post
title:  "Introduction to Dependency Injection"
description: "Dependency Inversion without all the magic. Review the basics and learn simple models of Dependency Injection Containers."
date:   2016-01-08 10:33:07
tags: dependency-injection dependency-inversion introduction basics Autofac StructureMap Nancyfx TinyIoc
image:
  feature: https://farm6.staticflickr.com/5269/5610940978_1195ce9cff_b.jpg
  credit: "The Wizard of Oz 0778 by Mraz Center - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/theatrebhs/5610940978/
---

I had the privilege of mentoring several co-workers in 2015. One of the
topics they found confusing was Dependency Injection. We use it everywhere. To
them it felt like magic. The code just fits together through mystical Containers.
In this post we will break down the powerful concepts surrounding
Dependency Injection.

Let's start with some simple classes:

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

These are all concrete classes. No fancy dependency magic
here. What this code does is very clear. ``Bar`` creates a ``Foo`` then
uses it to print ``Hello World``.

A complete program using this code is also straightforward:

{% highlight csharp %}
public class Program {
    static void Main() {
        Bar bar = new Bar();

        bar.Example();
    }
}
{% endhighlight %}

Create a new ``Bar`` then call ``Example``. Hello World!

Dependency Inversion Principle Applied
===============================================================================

Let's spice things up! Instead of creating the ``Foo`` in ``Bar``'s
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
callers using ``Bar``. We have switched from a concrete implementation to a higher level abstraction.
This decouples the code making it easier to maintain.

We have applied the [Dependency Inversion Principle][dip]<a href="#di-note-1"><sup id="reverse-di-note-1">1</sup></a>.
As defined by [Robert Martin][bob] it is:

> A. High level modules should not depend upon low level modules. Both should depend upon abstractions.
>
> B. Abstractions should not depend upon details. Details should depend upon abstractions.

[The abstraction could be anything][di-abstraction]. Typically it will be an
interface, but can also be a base class, delegate or another abstraction. The key
is shifting the code from the implementation to a higher level.

What About Dependency Injection?
===============================================================================

Another concept closely related to Dependency Inversion is Dependency Injection.
In fact, we used it without really knowing it. Where Dependency Inversion was
all about the abstractions and layers, Dependency Injection is all about how
dependencies are provided.

Don't worry, it is a really simple idea. Here is the demystified definition by [James Shore][james]:

> Dependency injection means giving an object its instance variables.

Literally, injecting dependencies into a class. In our previous example, we
injected our dependencies using constructor parameters. This is the
most common approach, but you can also inject dependencies using properties or specialized methods.

Look look at the program from the last example:

{% highlight csharp %}
public class Program {
    static void Main() {
        IFoo foo = new Foo();

        // Boom, IFoo injected!
        Bar bar = new Bar( foo );

        bar.Example();
    }
}
{% endhighlight %}

We inject the ``IFoo`` into the constructor of the ``Bar``. The program can
now choose which ``IFoo`` to use. This is more flexible than when the choice
was buried in the ``Bar`` class.

The Benefits
===============================================================================

We have inverted our dependencies and injected them
into our classes. This is fantastic! Our code is nicely decoupled. We can
easily change what is injected for testing or introducing new features.

Implementations are hidden
behind abstractions and can be easily replaced. Want an ``IFoo`` which writes
out to files? No problem. You can change the code to your new ``FileFoo`` without ever
modifying ``Bar``.

The original ``Bar`` is impossible to test in isolation. The direct dependency
on ``Foo`` forces the two classes to be tested together. Changes to ``Foo``
could break the tests for ``Bar``.

By injecting the dependencies, we can use a fake ``IFoo`` in
tests to do whatever we want. This is a great way to set up specific scenarios and/or avoid external
systems (i.e. databases or services).

Dependencies For Everyone!
===============================================================================

Creating classes is more challenging when you use Dependency Injection and
Dependency Inversion frequently.

We have moved where dependencies are created. This poses a problem for
consumers of the original classes. They must both choose what to inject and
create all the dependencies. I mean *ALL* the dependencies.

Your dependencies start to have their own dependencies. While this is not too bad with
a few dependencies, once you get into chains of dependencies it gets nasty.

Think about it. One class has a dependency, the
dependency has more dependencies and those dependencies have their own dependencies.
This is the tip of the iceberg:

{% highlight csharp %}
SqlConnection connection = new SqlConnection( "connection string" );

FooRepository repository = new FooRepository( connection );

Logger logger = new ConsoleLogger();

BazService controller = new BazService( repository, logger );
{% endhighlight %}

If every class repeated setups like this it would be a big problem. Creating anything
would be a nightmare. Thankfully there is a better solution, Dependency Injection Containers.

Dependency Injection Containers
===============================================================================

With all this dependency madness we need to find a better way to create classes.
Don't worry! There are fantastic libraries to address
this problem. They are commonly referred to as Dependency Injection Containers
or Containers for short.

Containers contain and seamlessly connect all of your dependencies. Within your
application they are used to instantiate dependencies they know about.

Before we get to the real thing I want to walk you through a mental
models for Containers.

* Externally they are like one massive Factory for any type
* Internally they are like a Dictionary of Factories

### Enter the Factories

A Factory is a common creational pattern. They allow you to abstract
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

The Factory can be used any time an ``IFoo`` is needed without any knowledge of which ``IFoo`` is created.
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

Factories can partially contain the sprawling dependencies. The more
dependencies you have the more factories you will need. Factories will need
to call other factories to create nested dependencies. This can get
complicated when many dependencies are needed. The extra classes and glue code
are tedious to maintain.

Prior to using ``IFoo`` we need to create one using the factory:

{% highlight csharp %}
public class Program {
    static void Main() {
        FooFactory factory = new FooFactory();
        IFoo foo = factory.Create();

        Bar bar = new Bar( foo );

        bar.Example();
    }
}
{% endhighlight %}

Having to use the factory everywhere is not fun. We can do better.

### Poor Man's Dependency Injection Container

What if we could use a single class to get any dependency we wanted?
We could use a Dictionary of Factories! The Dictionary would be keyed on types
where the values would define how to create their respective types.
We could then create any class the Dictionary knows about.

In this section, we are going to create a really simple class to do just
that. Our very own simple Dependency Injection Container.

Question: Why is it called a "Container"? It will contain all our application's dependencies.
When our application starts we will give it all the dependencies we want to
create and classes we want to inject the dependencies into.

The Container needs to:

1. Resolve types our application needs
2. Register types our application provides

Enough with the words! Onto the code!

{% highlight csharp %}
public interface ISimpleContainer {
    public T Resolve<T>();

    public void Register<T>( Func<T> factory );
}
{% endhighlight %}

Not bad. One method to ``Register`` dependencies and another to ``Resolve``
them. The methods line up with our "Factory for any type" and "Dictionary of Factories" mental models.
We accept ``Func<T>``'s as simple factories for each type. Once all the types
have been registered, ``Resolve`` behaves like a Factory for any type.

Let's implement our simple version:

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

Internally we have the "Dictionary of Factories". ``Resolve`` uses the
``Func<T>``'s we registered.

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

Cool. We have a Container. I would not use it in a real project. It is awkward
to use. The classes need to be wired together manually. We had to tell it
exactly how to create a ``Bar`` even though it already knew how to
create an ``IFoo``.

This is where real Dependency Injection Containers are fantastic. They solve
the wiring problem and automatically inject dependencies they know about.
We can use the Container like glue to bind everything together.

Abstractions are registered as concrete types. Consumers can resolve and use
those abstractions directly. They have no knowledge of the concrete types being
injected. Instead they rely on the Container. This preserves the Dependency
Inversion principle and helps decouple our code.

### Awesome Containers

Thankfully, there are many great open source Dependency Injection Containers.
The following three are my favourites. Our team has used them on different projects.

**[Autofac][autofac]**

Autofac is new, super clean and powerful. The registration
API is fun! They also have great support for
controlling [lifetimes/scoping][auto-life] and [cleaning up for you][auto-dispose].
This would be my first choice when starting a new application.

**[StructureMap][structuremap]**

StructureMap is battle hardened having been the original .NET Dependency Injection
Container. The latest version of StructureMap was a massive step forward. The authors
incoperated many improvements they learned from 10 years of supporting the project.
A great choice you should definitely check out.

**[TinyIoC][tinyioc] via [Nancy][nancyfx]**

Lastly, we use Nancy a lot! For the simpler applications, we exclusively use the
built-in TinyIoC. It is simpler than the other Containers and is missing some
advanced options. We periodically consider switching to one of the other
libraries for these features which we believe would simplify our configuration.

### More Out of the Box

These libraries greatly enhance how you register and resolve components.
Often these capabilities are connected; features used
when registering define how objects are resolved.

All the Containers can wire together classes based on what they need injected. You could
register ``Bar`` and when it is resolved the Container would automatically
inject an ``IFoo`` based on what was registered for ``IFoo``.

Here is an example of our application using Autofac:

{% highlight csharp %}
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

It does the right thing and gives ``Bar`` the registered ``ConsoleFoo``.

Many Containers have shortcuts for simple transformations, i.e. from ``T`` to ``Lazy<T>``.
Containers often support resolving/registering open generic types.

Containers can offer the ability to register sets of dependencies in
[Modules][auto-modules] or [Registries][sm-registry]. This provides a simple
way to group registrations together or split them apart. For example, you could
register all database related classes in one module separate from your logging
module.

Most Containers provide mechanisms
for registering your types based on conventions so you do not
need to configure everything by hand. You can register all classes
implementing a similar interface name, i.e. ``Foo`` would be registered
for ``IFoo``. This is cool for people who like conventions over configuration,
but can be too much magic other people. We use this approach and only configure
classes which violate our simple conventions.

Perhaps the greatest benefit is how they integrate with various frameworks.
Containers often have shortcuts to hook into popular web frameworks, like ASP.NET MVC or
Nancy. The framework can use the Container to resolve types it needs. We use this to create
Controllers and automatically inject their dependencies. This lets you use Dependency
Injection while decoupling your code from the Container itself. Everything
magically fits together.

The larger our applications become the more benefit we get from using Dependency Injection
Containers. We no longer worry about how we are going to wire our classes together. Instead, we can
focus on designing our interfaces and classes.

Connecting the Dots
===============================================================================

Phew, you made it this far! I hope this helped shed some light on Dependency
Injection and the surrounding concepts.

Instead of using concrete classes we switched to higher level dependencies,
applying Dependency Inversion. We needed to get those dependencies from
somewhere so we used Dependency Injection, via constructor parameters, to inject the
dependencies we wanted.

We explored Dependency Injection Containers using these mental models:

* Externally they are like one massive Factory for any type
* Internally they are like a Dictionary of Factories

Then we dug into complete Dependency Injection Containers and their extra features.

Have fun decoupling your dependencies!

<hr />

### Further Reading

There is so much more you can read and learn. While writing this post I found
these additional resources:

**[Autofac][auto-docs] and [StructureMap][sm-docs] Documentation**

Both these libraries are fantastic and their maintainers have put some serious
work into writing comprehensive documentation. They share many recommendations
and pitfalls for using their frameworks. The most interesting articles include
insights into the decisions they made and why they made them.

**[Container Guidelines][guidelines]**

Dependency Injection Containers impact how you design your application and need
to be treated with care. These recommendations will help you
avoid problems<a href="#di-note-2"><sup id="reverse-di-note-2">2</sup></a>.

**[DIP in the Wild][wild]**

Real life applications of Dependency Injection in the wild plus a good recap of
the concepts.

**[Inversion of Control Containers and the Dependency Injection pattern][injection]**

This is a more in-depth explanation of the concepts. The
closely related ideas of "Inversion of Control" and "Service Locators" are explained.
There is a review of best practices and trade-offs. Some of the best practices may be
a little dated, i.e. using a Service Locator instead of Dependency Injection Containers.

<hr />

### Footnotes

<a href="#reverse-di-note-1"><span id="di-note-1">1.</span></a> I could not get this link to work. I found it
via [this][di-abstraction] great article explaining how an abstraction is not synonymous with interfaces.

<a href="#reverse-di-note-2"><span id="di-note-2">2.</span></a> For some applications we intentionally call
the Container from our tests. We treat the Container configuration as part of our integration tests. I will
agree this is not ideal, but it simplifies creating various types and better mimics what our users will run.

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
