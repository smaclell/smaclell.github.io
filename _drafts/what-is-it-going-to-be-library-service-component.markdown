---
layout: post
title:  "What is it going to be? Library, Service or Component!"
date:   2014-10-01 23:35:07
tags: development design craig
---

Take Away
=======================================

Extending a existing system results in tradeoffs depending on where you choose
to make the change.

Consider using changing one of the following:

* A library along a known boundary
* A service behind a consistent protocol
* A component within a service

New Requirements
=======================================

A few weeks ago we had an interesting team discussion about how best to
introduce changes to a system we maintain. The system is fairly complicated
with a variety of moving pieces that collaborate together to form a complete
solution. Each piece typically has a [single responsibility][srp] and is fairly
specialized. We have also tried to limit the number of operations the overall
system performs. This minimalist intent resulted in a more focused design
targeting the current needs but included few extension points.

In a few areas we decided to create small services to perform long running
tasks or interact with other complex software. We tried to design the APIs
for these services generically so that other implementers use the same contract
in the future. We then use internal configuration for different options that
could modify the service behaviour while still closely reflecting the
implementation. Managing our configuration in this way hasn't all been a bed of
roses but we will come back to that in a different post.

We were approached by another team who wanted to extend our system so that they
could perform some of the operations differently. The new extensions would be
logically similar to the existing pieces but different enough that it put new
stress on our design and did not belong in the original components. Think Gala
apples to Granny Smith apples instead of apples to oranges. Our challenge was
to determine where in the system to make these changes.

Library, Service or Component?
=======================================

In talking to my boss, Craig, about the problem, we came up with three places we
could swap in the new functionality. These three places were within a single
library, a complete service or configuring a new component within an existing
service.

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

In the end we decided to swap out individual libraries. This included some
refactoring to isolate each operation performed by the system. The resulting
changes helped clarify how the system works and decouple the operations. The
service calls were also converted these new extension points which let us
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