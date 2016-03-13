---
layout: post
title:  "Dependency Injection Darkside"
description: "How we now setup our PowerShell projects to keep them easy to maintain."
date:   2015-12-30 23:45:07
tags: powershell conventions maintenance
image:
  feature: https://farm8.staticflickr.com/7528/15037595713_077b784de6_b.jpg
  credit: "The artist by Shawn Harquail - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/harquail/15037595713/
---

[Dependency Injection][di] is an addicting drug. Too much can be a bad thing.
If you are not careful using Dependency Injection everywhere can start
contorting your code in weird ways. This post reviews a few of the ways you can
get into trouble with Dependency Injection.

There are no silver bullets and Dependency Injection is no exception. This
powerful tool must be used with consideration to avoid problems.

**Dependency Madness, now with containers.** Complicated dependencies managed
by an Inversion of Control Container are not made simpler. In fact they become
harder to follow thanks to the extra separation between abstract classes and
implementations.

**Everything becomes a dependency.** Like a crazy [Katamari][katamari]
[ball][ball] absorbing everything it touches, Dependency Injection tends to be
a magnet for everything in an application. It is easy to get pulled in.

Not everything needs to be a dependency. Abstract interfaces/classes everywhere
are good for mocking, but tend to be less useful when debugging. Knowing which
class was used at runtime is important.

**Different Lifespans.** It can be easy to accidentally inject dependencies
which have a shorter lifespan than the class consuming them.

public class BadSingleton {
    public BadSingleton( IHttpContext context )
}

// The dependency injection setup via Autofac



Mixing per request and other life cycles

So many small fragile dependencies lead to hard to follow code.

[di]: TODO
[katamari]: https://www.youtube.com/watch?v=cwhFH75OCDs
[ball]: https://www.youtube.com/watch?v=aH2dbfVfurM
