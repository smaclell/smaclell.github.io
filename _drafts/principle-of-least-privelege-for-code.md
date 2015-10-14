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

Great. Restrict what exactly? I think the focus should be controlling
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