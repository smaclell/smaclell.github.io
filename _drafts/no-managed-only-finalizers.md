---
layout: post
title:  "No Managed-Only Finalizers"
description: "We had intermittently failing tests due to an unnecessary Finalizer. It was only being used with managed code. We didn't need one, you probably don't either."
date:   2015-12-25 1:17:07
tags: troubleshooting daryl chris testing
image:
  feature: https://farm4.staticflickr.com/3167/2962437091_d7ec9fdfb0_b.jpg
  credit: "Magic by Bart - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/cayusa/2962437091/
---

We cleaned up a fruity issues caused by using [.NET Finalizers][object] with managed classes.
Finalizers are a magical method called by the Garbage Collector. Like most
magic you need to be careful or you might saw your legs off.
While Finalizers might sound like a cool way to clean up after yourself they should
 only be used to cleanup unmanaged resources. Otherwise, they are not recommended
and can lead to instability.

There are two primary mechanisms for cleaning up resources in .NET:
Finalizers and ``IDisposable``.

Finalizers are meant to ensure unmanaged resources are cleaned up by the
Garbage Collector. They feel like a hold over from unmanaged code and I get
uncomfortable when I see them. In 99.9% of the managed code I have worked in they
don't belong.

Whereas most .NET classes implement the ``IDisposable`` interface to tidy up
after themselves. Closing database connections and cleaning up files are
standard examples. The interface works great for allowing your consumers clean
up resources when they want to instead of waiting for the Garbage Collector.

We were using Finalizers and were doing it wrong.

What went Wrong
===============================================================================

With Finalizers, like their C++ sibling destructors, it is important to pay
attention to how objects are connected. We ran into a problem where a Finalizer
was disposing the object which created it.

The classes ``TestData`` and ``TestUtility`` were used together in integration
tests to setup/cleanup data. The tests intermittently failed because the
``DataWeCareAbout`` was deleted when the ``TestData`` Finalizer ran.

Our classes looked roughly like this (minus a bunch of boring code):

{% highlight csharp %}
internal class TestData {
    private TestHelper m_helper;

    public TestData( TestHelper helper ) {
        m_helper = helper;
    }

    // The Bad Finalizer
    ~TestData() {
        m_helper.Dispose();
    }
}

internal class TestHelper : IDisposable {

    public TestData CreateData() {
        return new TestData( this );
    }

    public void Dispose() {
        m_conn.Execute(
            "DELETE DataWeCareAbout WHERE Id = @Id",
            new { Id }
        );
    }

}
{% endhighlight %}

Since Finalizers are called directly by the Garbage Collector the failures
were not consistent. They would happen if the Garbage Collector ran early in
the test run. We eventually found it by stepping through the code to isolate
what was deleting the data during the test. This led us to the Finalizers.

Daryl, a great developer I work with, insisted Finalizers should not be used
with only managed code. Their sole purpose is to ensure unmanaged resources can
be cleaned up even if the programmer forgets.

We had two problems:

* ``TestData`` disposed the ``TestUtility`` which deleted ``DataWeCareAbout`` too soon
* We should not have used a Finalizer at all


Finding More Finalizers
===============================================================================

We looked through our code base to see if more Finalizers were used elsewhere. We
only found one where it was needed and many others which needed to be removed.

The extra Finalizers were not needed at all! They had no unmanaged resources!
We deleted them without a second thought.

As an added bonus, they were using a fun pattern which mixes Finalizers and ``IDisposable``.
Consumers can proactively call ``Dispose`` and clean up the data. If that is
forgotten then the Finalizer will be used. This was complete overkill for the Finalizers
we didn't even need.

You can read more about this pattern and implementing Finalizers on [msdn][impl].
For completeness here is a sample of the pattern based on our code/msdn:

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

        // Only if explicitly disposing should you clean up unmanaged resources
        // We don't have any so there is no work to be done
        // if( disposing ) {
        //}

        // Clean up all unmanaged resources
        m_resource.Delete();
    }

}
{% endhighlight %}

Learning More
===============================================================================

It turns out having a [Finalizer][object] makes classes special. Here are a few
highlights which further convinced me I should avoid them like the plague:

* They are handled differently which [degrades performance][perf]
* When they are called is non-deterministic
* Any managed references may already be garbage collected and be horribly broken
* Are only for cleaning up unmanaged resources

Don't Do It
===============================================================================

Odds are you will never need a Finalizer. If you are not sure then you shouldn't
add one.

We were using it for automatic clean up with only managed code. This
was both lazy and wrong. Instead, we should have used ``IDisposable`` to
clean up at the end of the test.

We learnt a valuable lesson: **We didn't need Finalizers**

<hr />

*I would like to thank my co-workers, Daryl, Chris, [Michael Swart][swart] and Derek,
for digging into this issue with me. It was fun to find the eventual root cause,
fix this weird issue and learn more about Finalizers.*

[object]: https://msdn.microsoft.com/en-us/library/system.object.finalize(v=vs.110).aspx
[perf]: https://msdn.microsoft.com/en-us/library/ms973837.aspx#dotnetgcbasics_topic5
[impl]: https://msdn.microsoft.com/library/b1yfkh5e(v=vs.100).aspx
[swart]:    http://michaeljswart.com
