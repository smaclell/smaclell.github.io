---
layout: post
title:  "Knife Edge or Incremental Changes"
date:   2014-09-22 23:11:07
tags: thoughts
---

At two extremes are in place and incremental changes. You can either make
your changes to the entire system all at once or incremental in small pieces.
Between these extremes there are a spectrum of ways they can be mixed and
matched to form interesting solutions.

The tradeoffs focus on speed vs potential impact. The faster you make the
change the more impactful it will be. When things are going well the impact is
just what you want but if the change causes problems then things go downhill
fast. With in place changes that affect the entire system this can be "fun".

<div class="center-align">
<blockquote class="twitter-tweet" lang="en"><p>To make error is human. To propagate error to all server in automatic way is <a href="https://twitter.com/hashtag/devops?src=hash">#devops</a>.</p>&mdash; DevOps Borat (@DEVOPS_BORAT) <a href="https://twitter.com/DEVOPS_BORAT/status/41587168870797312">February 26, 2011</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>

In Place

* Great for small/simple/safe changes that happen infrequently
* Dangerous for any single points of failure
* Dangerous when done on the majority of the system
* Making the change and undo the change are two different operations
* Not good for high risk environments or changes

Incremental

* Not great for urgent changes
* Can minimize the effect to the existing version
* Easier to implement rollback
* May need to run multiple versions at once
* Making the change and undoing the change can be the same operation reversed

A common pattern for incremental updates would be swap out or change small
parts of the system without affecting the existing system. This reduces the
affect on the original system dramatically and can often be recovered by
switching back over to the original system using a load balancer or dns.

To learn more about common incremental techniques I would recommend:

* Swapping between [blue and green][BlueGreen] servers and rollback if there are problems
* Treat your servers as completely [immutable][ImmutableServers] and never make in place changes
* Send a small amount of traffic to the new release as a [canary][CanaryRelease] to validate the new functionality

-
Be aware of this, I think it is better, you might too.
Realzing you have these options.

Address the different labels for it then stick with it.
--> In place vs Incremental

really quick and could get stabbed.
Incremental an outage is never required.

A knife edge change would take effect right away

Lately, I have been heavily promoting incremental changes for the work we are
doing. For most situations I feel that they can performed more reliablely and
with higher reproducibilty.

Lets take an example. You are deploying an update to an existing service. BAM!

A) Change the code in place on the server and restart.
B) Make a new server and replace the original when it is done.

Option A) is the knide edge. What if it has defects? How do you test the
system to make sure that everything is up right? If things go poorly you get
cut! If things go well then you are probably done much faster.

How about Option B) doing it increntally? You needed a whole new server! That
takes time to make a new one. Maybe you are using Chef or Puppet or Ansible or
Bash to setup servers from scratch to make it reproducable. If something is not
right with the new server you can go back to the old one you have not changed
and the system can ideally keep running.

Some things are really hard to change safely all at once. Tke a major version udpatesdkasakskaksakasksakaskkaskakskakksakkk

Incrementally
=======================================

Changes are rolled out in pieces where they can be tested and if necessary
rolled back. You are never betting the farm on the changes that you are making
and they can be undone should things turn south. Successful changes build on
more sucessessful changes increasing the confidence in each step.

This process can be slower overall to complete but is typically much safer.
Newer techniques such as container and tools like Docker make doing changes
like this much faster. You can also pre-provision new servers/services prior to
when they would be used to mitigate the extra duration and then provide a
faster cutover for the system.

One variant of this is making the changes beside the existing system with a
side by side implementation. This can be something like a blue green deployment
where you are running two versions at once or canary deployments used by large
cloud systems.

Knife Edge
=======================================

You make your changes instantly in large changes. A common way to do it would
be to take your systems as they are and change them in place. This can be risky
business as it may prevent you from rolling back or result in less consistent
starting conditions. It is simple to do changes in this fashion. You need to be
very concious of what your rollback plan is and understand how to recover
safely if things go poorly.

This can be very useful when updating a critical piece of hardware like a load
balancer or core switch where costs and complexity make it prohibative to run
with sufficient redundancy to perform the change incrementally. Another good
application would be quickly switching the load of an application between
versions.


Thank Chris for helping edit this post and bouncing ideas off.

[DevOpsBorat]:      https://twitter.com/DEVOPS_BORAT
[BlueGreen]:        http://martinfowler.com/bliki/BlueGreenDeployment.html
[CanaryRelease]:    http://martinfowler.com/bliki/CanaryRelease.html
[ImmutableServers]: http://martinfowler.com/bliki/ImmutableServer.html