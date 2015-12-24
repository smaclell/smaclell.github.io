---
layout: post
title:  "Don't Mix Dispose and Finalizers"
description: "There are fun patterns in .NET around Finalizers and Dispose."
date:   2015-12-25 1:17:07
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

TODO: Good definition for both

Finalizers are meant to guarantee unmanaged resources are cleaned up by the
garbage collector. They are like destructor functions from C++ and need to be
handled with care. I think they feel like a hold over from another time and get
afraid when I see them. They are not natural in 99.9% of the managed code I have
worked with.

Whereas most .NET classes implement the ``IDispose`` interface to tidy up after
themselves. There are common use cases like closing database connections and
cleaning up files.

What went Wrong
===============================================================================

With Finalizers like their C++ sibling Destructors it is important to watch
object lifetimes. We ran into a problem where a Finalizer was disposing an
object which it did not own.

TODO: Confirm the code causing the problem

Our classes looked like this:

{% highlight csharp %}
internal class TestData {
    HoserDisposer m_disposer;

    ~BadFinalizer() {
        m_disposer.Dispose();
    }
}

internal class Helper : IDispose {

    public void Dispose() {
        m_conn.Execute(
            "DELETE TheDataYouCareAbout WHERE Id = @Id",
            new { Id }
        );
    }

}

{% endhighlight %}

They were used together within integration tests to setup/cleanup data. The
tests intermittently failed because the ``TheDataYouCareAbout`` was deleted
when the Finalizer ran.

Learning More
===============================================================================

Daryl. No Finalizer on managed code


Don't Cross The Streams
===============================================================================

For the cool kids there is even a pattern where you can blend the two.

Again?
===============================================================================

We looked through our code base to see if Finalizers are used elsewhere. We
only found one where it was needed and many others which needed to be removed.


Don't Do It
===============================================================================

Odds are if you never need a Finalizer. If you are not sure then you shouldn't
do it. We were using it for clean up and only with managed code. That was
wrong.

Follow our two simple rules:

* No Finalizers for only managed code
* Calling dispose in Finalizers

TODO: Review the morale of the post.

<hr />

*I would like to thank my co-workers, Daryl, Chris, Micheal Swart and Derek,
for digging into this issue with me. It was fun to find the eventual root cause
and fix this weird issue.*