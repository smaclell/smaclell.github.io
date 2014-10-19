---
layout: post
title:  "Knife Edge or Incremental Changes"
date:   2014-09-22 23:11:07
tags: thoughts
---

At two extremes are knife edge and incremental changes. You can either make
your changes right away sharply or in small pieces. Between them there is a
spectrum of ways they can be mixed and matched to form interesting solutions.

The tradeoff is speed vs safety. Both are perfectly viable options but you need
to plan ahead 

Single Points of Failure.
Incremental Minimal affect on the original system. Recovery is easier.
Up and Down are different operation for knife edge changes. Modifying the actual
thing and hoping that works out.

-
Be aware of this, I think it is better, you might too.
Realzing you have these options.

Address the different labels for it then stick with it. 
--> In place vs Incremental

really quick and could get stabbed.
Incremental an outage is never required.

Future Post:
Does the scale you make your change adjust it? Impact or potential affect of the change.

Bias for incremental
No one fixes thier car with the engine running.
Not a great analogy because they are different.

Car is critical.
House you can tolerate an outage.
Faulty switch, full replacement <= immutable, tinker in place to try and get it or just swap it.

Knife edge - Natural
Incremental - Not intuitive, not thinking the change will break things. More important to be up and working then to have the new change.

In place
Blue/Green

Real life example.

A knife edge change would take effect write away 

TODO Chris will review.

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

Thank Chris for helping me work through this and make it more concise.
