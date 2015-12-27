---
layout: post
title:  "Don't Mix Dispose and Finalizers"
description: "There are fun patterns in .NET around Finalizers and Dispose."
date:   2015-12-25 1:17:07
tags: troubleshooting daryl chris
---

TODO: Image of magic
TODO: Double check the interface name

We cleaned up a fruity issues caused by .NET Finalizers with managed classes.
Finalizers are a magical method called by the garbage collector. Like most
magic you need to be careful or you might saw your legs off.
While this might sound like a cool way to clean up after yourself they should
 only be used to cleanup unmanaged resources. If not they can lead
to instability and are not recommended.

There are two primary mechanisms for cleaning up resources in .NET, ``IDisposable``
and Finalizers.

TODO: Good definition for both

Finalizers are meant to ensure unmanaged resources are cleaned up by the
garbage collector. The closest analogy are destructors from C++ and need to be
handled with care. I think they feel like a hold over from another time and get
uncomfortable when I see them. They are not natural in 99.9% of the managed code I have
worked with.

Whereas most .NET classes implement the ``IDisposable`` interface to tidy up after
themselves. There are common use cases like closing database connections and
cleaning up files. The interface works great for allowing your consumers clean
up resources when they want to.

What went Wrong
===============================================================================

With Finalizers like their C++ sibling Destructors it is important to pay
attention to ownership. We ran into a problem where a Finalizer was disposing an
object which it did not create/own.

TODO: Confirm the code causing the problem

Our classes looked like this:

{% highlight csharp %}
internal class TestData {
    TestHelper m_helper;

    public TestData( TestHelper helper ) {
        m_helper = helper;
    }

    ~TestData() {
        m_helper.Dispose();
    }
}

internal class TestHelper : IDisposable {

    public TestData CreateData() {
        return new TestData();
    }

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
when the ``TestData`` Finalizer ran.

This was hard to find since when the code would run was not consistent. We
eventually found it by tracing what could be deleting the data and finding the
Finalizers.

Daryl, a great developer I work with, insisted Finalizers should not be used
with only managed code. Their sole purpose it to ensure unmanaged resources can
be cleaned up even if the programmer forgets.

So in addition to having the wrong class doing the clean up we were also using
the Finalizer wrong. In fact we shouldn't have been using them at all.

Learning More
===============================================================================

It turns out having a [Finalizer][object] makes classes special. They are called
by the Garbage Collector (GC) in order perform extra clean up.

* The GC handles them differently which can [degrade performance][perf]
* When they are called is non-deterministic
* Any managed references in the Finalizer could be horribly broken

Again?
===============================================================================

We looked through our code base to see if Finalizers are used elsewhere. We
only found one where it was needed and many others which needed to be removed.

Many were using a fun pattern which is a hybrid between Finalizers and Dispose
which were completely overkill for the classes. You can read more about
implementing Finalizers and this pattern on [msdn][impl]. Here is a sample
based on our code/msdn:

{% highlight csharp %}

public class Example : IDisposable {

    private bool m_disposed = false;
    private ScaryUnmanagedResource m_resource;

    public Example() {
        m_resource = new ScaryUnmanagedResource();
    }

    ~Example() {
        Dispose( false );
    }

    public void Dispose() {
        Dispose( true );
        GC.SupressFinalize( this );
    }

    protected virtual void Dispose( bool disposing ) {

        if( m_disposed ) {
            return;
        }

        // Only if explicitly disposing clean up unmanaged resources
        // We don't have any so there is no work to be done
        // if( disposing ) {
        //}

        // Clean up all unmanaged resources
        m_resource.Delete();

    }

}

{% endhighlight %}


Don't Do It
===============================================================================

Odds are if you never need a Finalizer. If you are not sure then you shouldn't
do it. We were using it for automatic clean up and only with managed code. That
was both lazy and wrong. Instead we should have used ``IDisposable`` and
carefully watched the ownership of the classes we were creating.

However, we learnt a valuable lesson:

**You should avoid Finalizers**

<hr />

*I would like to thank my co-workers, Daryl, Chris, Micheal Swart and Derek,
for digging into this issue with me. It was fun to find the eventual root cause
and fix this weird issue.*

[object]: https://msdn.microsoft.com/en-us/library/system.object.finalize(v=vs.110).aspx
[perf]: https://msdn.microsoft.com/en-us/library/ms973837.aspx#dotnetgcbasics_topic5
[impl]: https://msdn.microsoft.com/library/b1yfkh5e(v=vs.100).aspx
