---
layout: post
title:  "Knife Edge or Incremental Changes"
date:   2014-09-22 23:11:07
tags: thoughts
---

At two extremes are knife edge and incremental changes. You can either make
your changes right away sharply or in small constructive pieces. Between them
there is a spectrum of ways they can be mixed and matched to form interesting
solutions.

Lately, I have been heavily promoting incremental changes at our company. For
most situations I feel that they can performed more reliablely and with higher
reproducibilty.

TODO: form this into a more coherent presentation. Wrap it up and ship it.

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