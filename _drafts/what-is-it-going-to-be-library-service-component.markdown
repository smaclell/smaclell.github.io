---
layout: post
title:  "What is it going to be? Library, Service or Component!"
date:   2014-10-01 23:35:07
tags: development design craig
---

Take Away
=======================================

Consider where different changes could be made and the accompanying tradeoffs.
It might be as easy as swapping at one of the existing extension points.

New Requirements
=======================================

A few weeks ago we had an interesting team discussion about how best to
introduce changes to a system we maintain. The system is fairly complicated
with a variety of moving pieces that collaborate together to form a complete
solution. Each piece typically has a [single responsibility][srp] and is fairly
specialized. We have also tried to limit the number of operations the overall
system could perform. This minimalist intent resulted in a more focused design
targeting the current needs and few extension points.

In a few areas we decided to create small services to perform long running
tasks or interact with other complex software. We tried to design the APIs
for these services generically so that other implementers use the same contract
in the future. We then use internal configuration for different options that
could modify the service behaviour and closely reflect the implementation.
Managing our configuration in this way hasn't all been a bed of roses but we
will come back to that in a different post.

We were approached by another team who wanted to extend our system so that they
could perform some of the operations differently. The new extensions would be
logically similar to the existing pieces but different enough that it put new
stress on our design and did not belong in the original components.
Think gala apples to granny smith apples instead of apples to oranges. Our
challenge was where in the system to make these changes.

Library, Service or Component
=======================================

In talking to my boss, Craig, about the problem and we came up with 3 places we
could swap in the new functionality. These 3 places were within a single
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
the system. For example, the swapping the service would increase the important
of the API used to call the service or swapping the component would increase
the coupling to that specific service and the associated configuration.

Adjusting the library has the lowest operating cost but has the highest
impacting to anything running within the same process. Alternative libraries
would be best suited to use the same language/runtime. This route seems simple
and can keep the changes closer to where they would be consumed. This option
makes lots of sense when talking to other services that already manage their
own state.

Changing the service or underlying components are natural extension points
within a system like this. Running a new service may need additional hardware
and effort from operations. There may be more trouble getting started with this
method if your teams do not typically write many services.

Depending on the implementation of the service it may be easy to extend to add
the new functionality. This can effectively hide the change behind the existing
service. Using a new component within an existing service may dilute the
responsibilities performed by the service and diminish how specialized it can
be. More configuration would be required to enable the new capabilities.

Conclusion
=======================================

In the end we decided to swap out individual libraries. This required some
refactoring to isolate each operation performed by the system. The resulting
changes helped clarify how the system works and decouple the operations.

The existing service calls were also converted these new extension
points which let us move their implementations closer to the services they
consume. Had we decided to introduce a new service or component this would have
increased the work required to operate the system and configuration complexity.
The teams wanting to make the changes felt comfortable enough with this
approach that they contributed the new libraries that were needed.

Next time you are faced with a design decision like this consider whether
swapping a library, service or component would work for you.

[srp]: http://en.wikipedia.org/wiki/Single_responsibility_principle "A SOLID start"