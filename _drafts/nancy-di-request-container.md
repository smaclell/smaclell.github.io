---
layout: post
title:  "NancyFx's DI Request Container"
date:   2015-11-06 22:37:07
tags: troubleshooting dependency-injection nancyfx tinyioc viktor chris
---

This week my coworkers, Chris and Viktor, had a fun issue they had a hard time
getting to the root cause. They added some caching to speed up a heavily used
route which led to some unexpected tests breaking. In this post I wanted to dig
into the root cause for why it broke.

The one major lesson I learnt last year was the importance of
[getting to the root cause for unknown behaviour][rc]. My coworkers were doing
a focused performance improvement. On the surface the change was straight
forward. They wanted to add caching to specific request which requested the
same fields multiple times.

The values would be reused within the request to simplify the logic and keep
the cache invalidation rules simple. A new request could get new values and
we did not need to determine a period to keep the cached values. The solution
was to create a class per request which would read the underlying value once
then save it to a field. Every future request would use the value from the
field. The code used a simple delegate to the real implementation to get the
uncached value like this:

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

We adjusted our NancyBootstrapper configuration so TinyIoc would reuse
the same ``CachingProvider`` for each request and were off to the races.

{% highlight csharp %}
class NancyBootstrapper : DefaultNancyBootstrapper {

    protected override void ConfigureApplicationContainer(
        TinyIoCContainer container
    ) {
        base.ConfigureApplicationContainer( container );
    }

    protected override void ConfigureRequestContainer(
        TinyIoCContainer container,
        NancyContext context
    ) {
        base.ConfigureRequestContainer( container, context );

        container.Register<IProvider>( (x, options) => {
            IProvider implementation = x.Resolve<RealProvider>();
            return new CachingProvider( implementation );
        } );
    }
}
{% endhighlight %}

Trouble In Paradise
===============================================================================

Code was fine. However, it oddly broke an integration tests which seemed unrelated.

The test which broke was a larger integration test which faked a bunch of code
to cut out dependencies which would slow down the tests or need to be
controlled so we can create different cases.

With some more investigation we found out ``IProvider`` was one of the types we
were faking out. We tracked down some code in the test which registered it's
own implementation to overwrite the actual real types. The test dependency
injection configuration is like:

{% highlight csharp %}
class TestBootstrapper : NancyBootstrapper {

    protected override void ConfigureApplicationContainer(
        TinyIoCContainer container
    ) {
        base.ConfigureApplicationContainer( container );

        container.Register<IProvider, TestProvider>();
    }
}
{% endhighlight %}

Although we had found out what broke we still had not fixed it or learnt why
it broke.


Getting It Working
===============================================================================

After many hours of debugging and head to desk slamming Chris and Viktor managed
to fix the issue by changing how the registration was overridden. The approach
they used was to replace the registration for the faulty type they had modified.
This change was pretty invasive and added new methods to be overridden.

In the normal bootstrapper they added a virtual method which would
register the updated type:

{% highlight csharp %}
class NancyBootstrapper : DefaultNancyBootstrapper {

    protected override void ConfigureApplicationContainer(
        TinyIoCContainer container
    ) {
        // Register other dependencies
    }

    protected override void ConfigureRequestContainer(
        TinyIoCContainer container,
        NancyContext context
    ) {
        // Register other dependencies

        RegisterProvider( container );
    }

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

Then in the test bootstrapper we could override the new method to supply the
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

This worked but they did not understand the root cause behind what was broken.
Several other methods were moved around to accommodate the change. We did not
like this and knew there must be a better way.

Going Deeper: The Root Cause
===============================================================================

They were right, the root cause was dependency injection. However, their
solution worked bypassing the reason it was broken.

If you look closely at the code samples above you can see the type switched
from being registered for the Application to registered for each Request. While
this seems fine it meant the tests would resolve the actual type instead of the
fake ``IProvider`` they should be using.

The per Request dependencies are registered with a separate
``TinyIoCContainer`` which is a child for the Application container. When the
types are resolved the Request container is tried first and if nothing is found
then the Application container is tried. If nothing is found the dependency
fails to resolve which can cause an exception.

TODO: Picture of the hierarchy

With this new knowledge the fix was relatively straight forward. We registered
the fake ``IProvider`` per Request and the problem was solved.

{% highlight csharp %}
// Fixed Test Boot
class TestBootstrapper : NancyBootstrapper {

    protected override void ConfigureApplicationContainer(
        TinyIoCContainer container
    ) {
        base.ConfigureApplicationContainer( container );

        // Previously configured here
        // container.Register<IProvider, TestProvider>();
    }

    protected override void ConfigureRequestContainer(
        TinyIoCContainer container,
        NancyContext context
    ) {
        base.ConfigureRequestContainer( container, context );

        // Fixes the root cause and overwrites the new IProvider
        container.Register<IProvider, TestProvider>();
    }
}
{% endhighlight %}

Public Service Announcement
===============================================================================

The one major lesson I learnt last year, was it is important to understand
how your code works (TODO: Link). Have fun. Get to the root cause.

[rc]: {% post_url 2015-03-04-lessons-learnt-while-finding-the-root-cause %}