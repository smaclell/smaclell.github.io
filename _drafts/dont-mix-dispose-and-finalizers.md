---
layout: post
title:  "Don't Mix Dispose and Finalizers"
description: "There are fun patterns in .NET around Finalizers and Dispose."
date:   2015-12-18 1:17:07
tags: troubleshooting daryl chris
---

TODO: Image of magic
TODO: Double check the interface name

We cleaned up a fruity issues caused by .NET Finalizers on managed classes.
Finalizers are a magical method called by the garbage collector. Like most
magic you need to be careful or you might saw your legs off.
While this might sound like a cool way to clean up after yourself it leads
to instability and is not recommended.

There are two primary mechanisms to clean up resources in .NET, ``IDispose``
and Finalizers.

Finalizers are meant to guarantee unmanaged resources are cleaned up by the
garbage collector. They are like destructor functions from C++ and need to be
handled with care. I think they feel like a hold over from another time and get
afraid when I see them. They are not natural in 99.9% of the managed code I have
worked with.

Whereas most .NET classes implement the ``IDispose`` interface to tidy up after
themselves. There are common use cases like closing database connections and
cleaning up files. For the cool kids there is even a
pattern where you can blend the two.

<hr />

*I would like to thank my co-workers, Daryl, Chris, Micheal Swart and Derek,
for digging into this issue with me. It was fun to find the eventual root cause
and fix this weird issue.*