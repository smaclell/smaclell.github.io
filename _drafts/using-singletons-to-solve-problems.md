---
layout: post
title:  "Using Singletons To Solve Problems Is Wrong"
date:   2015-12-06 22:37:07
tags: design-patterns design daryl
---

The Singleton pattern is normally not what you want to use. It is great for
optimizing creating objects, but otherwise has limited utility. Recently, I
had a problem where I briefly considered using a singleton to deal with it.
Using a singleton to solve my problem would have been wrong and led to more
problems.

I was refactoring some code which had some unusual data access. It used a
per user key/value store to save data and then later retrieve it. The data
being saved was pretty simple and the code was acting like a really fancy
cache.

We decided to use the same key/value store for all users. Due to what the value
represented it made sense for every user to see the same data. Since the code
was behaving like a cache, using a slightly wider scope would allow the cached
value to be used more often.

I thought I could take a shortcut. Since the values would be identical for all
users then why not use a Singleton to store the value in memory. We could remove
the key/value store completely and simplify the code. Or so I thought.

TODO: Picture of before/after

Intervention
===============================================================================

But Scott you say, "what about other servers!". You are right other servers
would need the singleton too! Umm, Scott ... they would have different values.
Oh right.

The in memory singleton starts to have issues immediately coordinating between
multiple servers. There are a bunch of problems like:

* Different servers would have different values
* Access to the data needs to coordinated across threads
* Restarting the application loses the values

Thankfully my co-worker, Daryl, reminded me of the problems a Singleton would
cause. Instead we used decided to store the value in the application's database.
It also meant we could stop worrying about cache invalidation and simplify the
code since the database would always have the right value. Great. Problem solved.

The Bigger Picture
===============================================================================

After this brief lapse of sanity, we talked a little more about why Singletons
don't make sense in your architecture. By definition, Singletons are a single
point of failure and cannot be scaled out. For any system with enough load
you want neither of those.

Some Singletons in your architecture are HARD to avoid, like the centralized
database you use everywhere. Do whatever you can to make it redundant and
continue to scale as your application grows. Such Singletons may just be part
of doing business and once baked into the architecture are not worth the cost
to replace.

You may have operations which should only run in one place. Not a problem,
use a semaphore (or [leader election][leader] like the cool kids) to coordinate
who runs the operation then only run it in one place. Whatever runs the
operation can be scaled, redundant and perform many other useful operations.

A better question is why do you have this operation/service which can only be
run once? Do what you can to allow it to run in multiple places. If they
fails shrink the part which needs to be exclusive as much as possible to avoid
contention. Again consider making who and where it is running more flexible.

Optimization
===============================================================================

So when does a Singleton make sense? To avoid allocating many small objects or
very expensive objects.

Both these cases are optimizations to existing code based
on specific circumstances. Prior to using a Singleton you should investigate the
problem completely and determine what options you have available.

Again this would be a specific micro-optimization which would ideally be
transparent to the rest of the application. In our applications we often have
classes created once then injected into any class which needs them. The consuming classes have no idea
that they are using the same instance as every other consumer. This works
great for functional classes without any state.

Depending on how the component is
used you need to consider concurrency. The cpu/memory gains from reusing the
same object may be completely lost due to the overhead of thread synchronization.

Not the Tool for the Job
===============================================================================

In the end an in memory Singleton was not the right tool for the job. In
thinking about it further it is probably not the right tool for many jobs.
We were able to easily solve the problem using other techniques.

My example wasn't even using the complete Singleton Pattern and it was still bad!
For more reading check these out:

* [What is so bad about singletons?][bad]
* [Singleton Considered Stupid][stupid]
* [Why Singletons are Evil][evil]

To recap: Singletons are bad, stupid and evil.

If you think a Singleton is the perfect solution to your problem, double check.
There is probably different solution which fits better.

[leader]: https://en.wikipedia.org/wiki/Leader_election
[bad]: http://stackoverflow.com/questions/137975/what-is-so-bad-about-singletons
[stupid]: https://sites.google.com/site/steveyegge2/singleton-considered-stupid
[evil]: http://blogs.msdn.com/b/scottdensmore/archive/2004/05/25/140827.aspx
