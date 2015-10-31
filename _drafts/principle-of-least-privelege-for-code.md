---
layout: post
title:  "Principle of Least Privilege for Code"
date:   2015-09-29 22:37:07
tags: preflights builds ci daryl quality
---

Recommendation: Write the post then work on breaking it down. Idea, Extension and Practice are three possible ways.

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

Great. So we can apply the idea to code too. Restrict what exactly? I think the focus should be controlling
visibility between classes/assemblies. This also naturally leads to strictly
defining your public API. After all if you have not exposed it then it remains
private. Anyone else does not have enough privilege to use you code outside of
the limited surface area you define.

You want to be very intentional with what you make public. Anything you make
public will need to be supported, maintained and versioned over time. I think
it is important to strive for clean minimalist APIs which provide the exact
functionality they were designed to provide.

Strive for private by default. Everything not public can be more easily
refactored and improved. By keeping as much code private/internal you can you
decrease the surface area of the public API. If it ain't pubic it is private.

In this post I am going to go show how to control visibility in C#. With these
tools you can shape your classes to only allow the behaviour and visibility you
want.

The Basics: Classes
===============================================================================

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
instantiated and cannot have normal class variables. Great for helper classes
which contain methods or does not need to save any state within the class. In
order to create extension methods your class must be static.

Deeper Inside Classes
===============================================================================

private
protected
internal
internal protected ;)
public

abstract
virtual
static

const
readonly

Advanced

immutabable classes (get, but no set)
what about tests? The exception I would make to this is allowing test classes to access internal classes.
As little as you can in web API's
Consider the future, wait until then to act on it.

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