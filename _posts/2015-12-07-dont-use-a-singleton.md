---
layout: post
title:  "Don't Use A Singleton"
description: "Singleton objects (and the wider Singleton Pattern) are not normally what you want to use to solve problems"
date:   2015-12-07 00:12:07
tags: design-patterns design daryl
---

Singleton objects are not normally what you want to use to solve problems. It is great for
optimizing creating objects but otherwise has limited utility. Recently, I
had a change where I briefly considered using a Singleton to deal with it.
Using a Singleton to solve my problem would have been wrong and led to more
problems.

I was refactoring some code which had some unusual data access. Each user used
a key/value store to save data and then later retrieve it. The data being saved
was pretty simple and the code treated the key/value as a really fancy cache.

We decided to use the same key/value store for all users. Based on the data it
made sense for every user to see the same values. Sharing between users would
make the cache more effective.

I thought I could take a shortcut. Since the values would be identical for all
users then why not use a Singleton object to store the value in memory. Every time
the class was used we could return the same object and store the necessary value
in a field. We could remove the key/value store completely and simplify the code.
Or so I thought.

In the amazing image below, you can see what the code would look like before and
after using a Singleton to refactor the code.

<figure class="image-center">
	<img
		title="Before everyone works alone, after it is a party!"
		alt="A comparison of before and after. Before shows 3 people with their own key/value stores. After has the same 3 people all using the Singleton."
		src="{{ site.url }}/images/singletons-before-after.JPG" />
</figure>

<div class="disclaimer">
This isn't the complete Singleton Pattern. My use case would have reused the same
object for the entire application without needing to restructure how the class was
accessed. I have included links discussing the full Singleton Pattern at the end
of this post. They come to the same conclusion.
</div>

Intervention
===============================================================================

But Scott you say, what about other servers! Other servers
would need the Singleton too! Umm, Scott ... they would have different objects.
Oh right.

The Singleton object starts to have issues immediately coordinating the same value
between multiple servers. There are a bunch of problems like:

* Different servers would have different objects
* Access to the data needs to be coordinated across threads
* Restarting the application loses the saved values

Thankfully my co-worker, Daryl, reminded me of the issues a Singleton would
cause. Instead, we decided to store the value in the application's database.
It also meant we could stop worrying about cache invalidation and simplify the
code since the database would always have the right value. Great. Problem solved.

Using a Singleton to make this change is wrong. It would introduce other
issues which could be trivially avoided using other solutions.

The Bigger Picture
===============================================================================

After this brief lapse of sanity, we talked a little more about why Singletons
don't make sense in your architecture. By definition, Singletons are a single
point of failure and cannot be scaled out. For any system with enough load
you want neither of those.

Some Singletons in your architecture are HARD to avoid, like a centralized
database you use everywhere. Do whatever you can to make it redundant and
continue to scale as your application grows. Such Singletons may just be part
of doing business and once baked into the architecture are not worth the cost
to replace.

You may have operations which should only run in one place. Not a problem,
use a semaphore (or [leader election][leader] like the cool kids) to coordinate
who runs the operation then only run it in one place. Whatever runs the
operation can be scaled, redundant and perform many other useful operations.

A better question is why do you have this operation/service which can only be
run in one place? If the code is important enough and needs more throughput you
may need to deal with your Singleton. Do what you can to allow it to run in
multiple places at the same time. If that fails, shrink the code which needs to
be exclusive as much as possible to avoid contention. Again consider making who
and where it runs more flexible.

An Optimization
===============================================================================

So when does a Singleton object make sense? To avoid allocating many small objects or
very expensive objects.

Both these cases are optimizations to existing code based
on specific circumstances. Prior to using a Singleton, you should investigate the
problem completely and determine all options you have available.

Using a Singleton like this should be a specific micro-optimization which is
transparent to the rest of the application. In our applications, we have some
classes which are created once then injected into any class which needs them.
The consuming classes have no idea that they are all using the same object.
This works great for functional classes without any state or which talk directly
to our centralized database.

Depending on how your component is
used you need to consider concurrency. The CPU/memory gains from reusing the
same object may be completely lost due to synchronization overhead.

Not the Tool for the Job
===============================================================================

In the end, a Singleton object was not the right tool for the job. In
thinking about it further, it is probably not the right tool for many jobs.
We were able to easily refactor the code using other techniques.

My example wasn't even using the complete Singleton Pattern and it was still bad!
For more reading on why Singletons are the worst:

* [What is so bad about singletons?][bad]
* [Singleton Considered Stupid][stupid]
* [Why Singletons are Evil][evil]

To recap: **Singletons are bad, stupid and evil**.

If you think a Singleton is a perfect solution to your problem, double check.
There is probably different solution which fits better.

[leader]: https://en.wikipedia.org/wiki/Leader_election
[bad]: http://stackoverflow.com/questions/137975/what-is-so-bad-about-singletons
[stupid]: https://sites.google.com/site/steveyegge2/singleton-considered-stupid
[evil]: http://blogs.msdn.com/b/scottdensmore/archive/2004/05/25/140827.aspx
