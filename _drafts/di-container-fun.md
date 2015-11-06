---
layout: post
title:  "Dependency Injection Fun in NancyFx/TinyIoC"
date:   2015-11-06 22:37:07
description: "A story about digging into an issue with dependency injection in NancyFX and TinyIoC we caused then fixed"
tags: troubleshooting dependency-injection nancyfx tinyioc viktor chris
---

This week my coworkers, Chris and Viktor, had a fun issue where it was hard to
find the root cause. They added some caching to speed up a heavily used
API which led to some tests breaking unexpectedly. In this post I wanted to dig
into the root cause behind why the tests broke.

The one major lesson I learnt last year was the importance of
[getting to the root cause for unknown behaviour][rc]. My coworkers were doing
a focused performance improvement. On the surface the change was straight
forward. They wanted to add caching to a specific request which queried the
same values multiple times.

To simplify the logic they decided to reused the same values ever time it was
used during a request. This kept the caching rules really simple and meant
we did not have to care about cache invalidation. A new request could get new values and
we did not need to determine how long cached values are valid.

The solution
was to create a class per request which would read the underlying value once
then save it to a field. To get the underlying value we delegate to the
real provider. Every future query for the value would return the
saved value from the field. The code for this new caching looks like:

{% highlight csharp %}
class CachingProvider : IProvider {
    string m_value;
    readonly IProvider m_inner;

    internal CachingProvider( IProvider inner ) {
        m_inner = inner;
    }

    public string GetValue() {
        if( m_value != null ) {
            return m_value;
        }

        m_value = m_inner.GetValue();
        return m_value;
    }
}
{% endhighlight %}

We adjusted our dependency injection configuration to create one
``CachingProvider`` per request. For this application we are using
[NancyFX][nancy] with the built in [TinyIoC][tinyioc] dependency injection
container. To perform the change we updated our NancyBootstrapper configuration
so TinyIoc would reuse the same ``CachingProvider`` for each request.
Then we were off to the races!

{% highlight csharp %}
class NancyBootstrapper : DefaultNancyBootstrapper {

    protected override void ConfigureRequestContainer(
        TinyIoCContainer container,
        NancyContext context
    ) {
        // Register other types here

        container.Register<IProvider>( (x, options) => {
            IProvider implementation = x.Resolve<RealProvider>();
            return new CachingProvider( implementation );
        } );
    }
}
{% endhighlight %}

Trouble In Paradise
===============================================================================

The code cached the new values fantastically. The bad pages were now much better.
However, the change broke an integration tests which seemed unrelated.

The broken test was a large integration test which faked a bunch of tricky
dependencies. These special dependencies needed to be updated so we could
control the test behaviour.

With some more investigation we found out ``IProvider`` was one of the types we
were faking out. We tracked down the test code which registered it's
own implementation of ``IProvider`` to overwrite the real type. This was again
done via the dependency injection container like so:

{% highlight csharp %}
class TestBootstrapper : NancyBootstrapper {

    protected override void ConfigureApplicationContainer(
        TinyIoCContainer container
    ) {
        // Register other types here

        container.Register<IProvider, TestProvider>();
    }
}
{% endhighlight %}

Although we had found out what broke the test, we still had not fixed it or learnt why
it broke.


Getting It Working
===============================================================================

After many hours of debugging and head to desk slamming Chris and Viktor managed
to fix the issue by changing how the registration was overridden. They
replaced how ``IProvider`` was registered with a method which could be overridden.
This change was pretty invasive and also moved around how other types were registered (not shown here).

In the normal bootstrapper they added a virtual method to register the updated type:

{% highlight csharp %}
class NancyBootstrapper : DefaultNancyBootstrapper {

    protected override void ConfigureRequestContainer(
        TinyIoCContainer container,
        NancyContext context
    ) {
        // Register other dependencies

        RegisterProvider( container );
    }

    // The new method they added
    protected virtual void RegisterProvider(
        TinyIoCContainer container
    ) {
        container.Register<IProvider>( (x, options) => {
            IProvider implementation = x.Resolve<RealProvider>();
            return new CachingProvider( implementation );
        } );
    }
}
{% endhighlight %}

Then in the test bootstrapper they override the new method to register the
fake ``IProvider``:

{% highlight csharp %}
class TestBootstrapper : NancyBootstrapper {

    protected override void RegisterProvider(
        TinyIoCContainer container
    ) {
        container.Register<IProvider, TestProvider>();
    }
}
{% endhighlight %}

This worked but they still had not gotten the the root cause as to why the test
was broken. They had only addressed the symptom which was causing the test to fail.
It is not shown here, but several other methods were moved around to accommodate the change. We did not
like this and knew there must be a better way.

Going Deeper: The Root Cause
===============================================================================

If you look closely at the code samples above you can see the type switched
from being registered for the Application to registered for each Request. While
this seems fine it meant the tests would resolve the actual type instead of the
fake ``IProvider`` they should be using.

The per Request dependencies are registered with a separate
``TinyIoCContainer`` which is a child of the Application container. When the
types are resolved the Request container is tried first and if nothing is found
then the Application container is tried. If nothing is found the dependency
fails to resolve which can cause an exception.

<figure class="image-center">
	<img
		src="/images/di-levels.jpg"
		alt="An image of the Application and Request containers with the TestProvider and CachingProvider respectively beside them">
	<figcaption>
		The test failed because it found the new CachingProvider instead of the TestProvider it needed.
	</figcaption>
</figure>

With this new knowledge the fix was relatively straight forward. We registered
the fake ``IProvider`` per Request. This overwrites the ``CachingProvider``
registration with the ``TestProvider`` and the solves the problem.

{% highlight csharp %}
// Fixed Test Boot
class TestBootstrapper : NancyBootstrapper {

    protected override void ConfigureApplicationContainer(
        TinyIoCContainer container
    ) {
        // Register other types here

        // Previously configured here
        // container.Register<IProvider, TestProvider>();
    }

    protected override void ConfigureRequestContainer(
        TinyIoCContainer container,
        NancyContext context
    ) {
        // Register other types here

        // Fixes the root cause
        container.Register<IProvider, TestProvider>();
    }
}
{% endhighlight %}

Public Service Announcement
===============================================================================

Phew. You made it this far. What is the major lesson?

> It is important to [understand how your code works][rc]!
> Especially when it doesn't.

We went deeper into Nancy and figured out how the dependency injection worked!
It was great. Afterwards we could make the fix in a much simpler way.

Next time you are troubleshooting an issue make sure you find the root cause.
Going deeper is worth the extra time. You will understand the problem better
and the next time something comes up you will know what to do.

Until then happy troubleshooting.

[rc]: {% post_url 2015-03-04-lessons-learnt-while-finding-the-root-cause %}
[nancy]: http://nancyfx.org/
[tinyioc]: https://github.com/grumpydev/TinyIoC