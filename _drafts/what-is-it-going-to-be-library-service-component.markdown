---
layout: post
title:  "What is it going to be? Library, Service or Component!"
date:   2014-10-01 23:35:07
tags: development design craig
---

Take Away
=======================================

Extending an existing system results in tradeoffs depending on where you choose
to make the change.

Consider making your changes in one of the following areas:

* A new library along a known boundary
* A new service behind a consistent protocol
* A new component within an existing service

New Requirements
=======================================

A few weeks ago we had an interesting team discussion about how best to
change the system we use to orchestrate updates and deployments for
some of our products. The main activities are performed by a series of scripts
that call other services or libraries to do additional work. Each piece
that makes up the system specializes in a [single responsibility][srp].
We have also tried to limit the number of operations the overall
system performs to focus the design on our current needs.

The services are primarily used to interact with our infrastructure and/or
perform long running tasks. One service we have made,
Machinator, is used to simplify the creation and deletion of virtual machines.
It has a very generic API to abstract the underlying implementation and
allow other implementers to use the same contract in the future.

Configuration in Machinator modifies what underlying hardware is used to create
new virtual machines. This aligns closely with the underlying hypervisor which
simplifies the code and operating the service. This has led to many internal
settings that need to be configured which hasn't always been a bed of roses but
we will come back to that in a different post.

We were approached by another team who wanted to use a different virtualization
platform and load balancer. The orchestration scripts already did these
operations but only in very specific ways and only with integrations we had
implemented, like the virtualization consumed by Machinator. This placed new
stress on our design because these additions did not belong in the original
components. Our challenge was to determine where in the system to make these
changes without over complicating future maintenance.

Library, Service or Component?
=======================================

In talking to my boss, Craig, about the problem, we came up with three places
where we could introduce the new functionality. These three places were as a
standardized library, a similar service or configuring a new component within
an existing service. In this way you could swap any one of these building
blocks with existing functionality to change the behaviour of the workflow.

<p class="center-image">
	<img
		title="Yes, this image was made using paint."
		alt="The three places to make the change, i.e. library, service or component"
		src="/images/posts/LibraryServiceOrComponent.png" />
</p>

These options present a range of benefits and trade-offs. The options provide
different code isolation and maintainability challenges. Each choice would
further increase the importance of how that area is connected to the rest of
the system. For example, swapping the service would increase the importance
of the API used to call the service or swapping the component would increase
the coupling to that specific service and the associated configuration.

Adjusting the library has the lowest operating cost but has the highest
impact to anything running within the same process. Alternative libraries
would be best suited to use the same language/runtime. This route seems simple
and can keep the changes closer to where they would be consumed. This option
makes a lot of sense when talking to services that already manage their
own state.

Changing the service or underlying components can be natural extension points
within a system like this. Running a new service may need additional hardware
and effort from operations. There may be more trouble getting started with this
method if your teams do not typically write many services. A completely new
service is unencumbered by the choices made by the existing services and
libraries.

Depending on the current services their implementations may be easily extended
to add the new functionality. Doing so would effectively hide the changes
behind the existing service APIs. There is a risk that the responsibilities of
the enhanced service would become diluted with the new functionality or would
lose the benefits of being highly specialized. More configuration would
probably be needed to enable the new capabilities.

Conclusion
=======================================

In the end we decided to swap out individual libraries called by the scripts.
We needed to refactor some of the operations to better isolate them. The resulting
changes helped clarify how the system works and decouple the operations. The
service calls were also converted to these new extension points which let us
move their implementations closer to the services they consume.

Had we decided to introduce a new service or component this would have
increased the effort required to operate the system and configuration
complexity. Operators were already not thrilled with the necessary
configuration for the system which made these options even less attractive.
The teams wanting to make the changes felt comfortable enough with this
approach that they contributed the new libraries that were needed.

Next time you are faced with a design decision like this consider whether
swapping a library, service or component would work for you.

*I would like to thank [Michael Swart][swart] and Matt Campbell for helping
review this and several other of the early posts.*

[srp]: http://en.wikipedia.org/wiki/Single_responsibility_principle "A SOLID start"
[swart]: http://michaeljswart.com