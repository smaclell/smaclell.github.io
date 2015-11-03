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
field. The code used a simple delegate to the real implmentation to get the
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

We adjusted our NancyBootstrapper configuration so TinyIoc would create reuse
the same ``CachingProvider`` for each request and were off to the races.

Trouble In Paradise
===============================================================================

Code was fine, oddly broke an integration tests which seemed unrelated.
Test faked big chunks of the application including the area they changed.

Getting It Working
===============================================================================

They were able to track the problem down to the dependency injection of their
new component, but did not know why. The test was replacing the component they
had updated, but it had stopped working. Show original registration.

After many
hours of debugging and head to desk slamming they managed to fix the issue by 
allowing the registration to be overridden directly. This worked by the did
not understand the root cause behind what was broken.

Going Deeper: The Root Cause
===============================================================================

They were right the root cause was dependency injection. Their solution worked
bypassing the reason.

The root cause obscured by me for story telling ;) was because they switched
from registering the type at the application level to the request level. The
framework uses 2 di containers, one for the whole application and a child
per request. The caching was done by creating a new object and caching in the
object. We used DI to create the object only once per http request.

Previously,
the type was registered at the application. The test then registered the type
with what it wanted. When the registration moved from the application to the
request it broke.

Having two levels of container is common. The child container is used first
and then if a dependency cannot be found it then tries the application
container.

Public Service Announcement
===============================================================================

The one major lesson I learnt last year, was it is important to understand
how your code works (TODO: Link). Have fun. Get to the root cause.

[rc]: {% post_url 2015-03-04-lessons-learnt-while-finding-the-root-cause %}