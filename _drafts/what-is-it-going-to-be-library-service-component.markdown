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

In talking to my boss, Craig, about the problem, we came up with three areas
where we could introduce the new functionality. By replacing one of these
building blocks with a different implementation that provided the desired
functionality or integration. Using compilation or runtime configuration the
system could then determine which concrete implementation to use, such as green
or blue in the diagram below. The areas within our scripts/workflow we
identified were:

* A library, script, executable or dll along a known boundary
* A service behind a consistent protocol
* A component or classes within an existing service

<p class="image-center">
	<img
		title="The different options in full techni-colour. There are even scrolls!"
		alt="Replacing a library, service or component"
		src="{{ site.url }}/images/posts/LibraryServiceOrComponent.png" />
</p>

These options present a range of benefits and trade-offs such as how isolated the
change is and the ongoing maintenance cost. The boundary used to isolate the
change becomes more important and harder to evolve in the future. For example,
replacing Machinator with a service that used the same protocol/contract would make it
harder to change the protocol/contract being used. Similarly, adding the
functionality using configuration within Machinator would make Machinator more
important and harder to maintain in the future.

Using a different library has the lowest operating cost but might impact other
things running in the same process. It would make sense to use the same
language/runtime and might be necessary depending on how the library is loaded
and invoked. This route seems simple and in our system would keep the changes
closer to the entry point instead of buried deep within other layers. Another
complexity would be if the operation needed to preserve long running state
which would make a standalone library less suitable.

Replacing a service can be a natural extension point due to the existing API
boundary. Running a new service will undoubtedly need additional hardware and
support from operations. There may be more trouble getting started if your teams
does not typically write many services and have not optimized for a service
oriented or microservice architecture. Since using [microservices][fowler] is the new
hotness you can find out the [good and bad][micro] thanks to all that has been
written about it in the past few months.

Depending on the current services their implementations may be easily extended
to add the new functionality. Doing so would effectively hide the changes
behind the existing service APIs limiting their impact on the rest of the
system. There is a risk that this would over complicate the service being
updated and dilute its responsibilities. When evaluating this option for
Machinator we determined that new configuration would have been needed to
choose between the existing functionality and the new capabilities. This
approach could make it easier to use a mixture of the old and new functionality
at the same time, i.e. creating some virtual machines with each virtualization
platform within the same deployment.

Conclusion
=======================================

In the end we decided to better define boundaries within the scripts so that we
could use different libraries. This required more refactoring due to our
dependencies against the existing services and processes. The resulting changes
helped clarify how the system works and decouple the operations better from the
scripts. The service calls were also converted to these new extension points
which let us move their implementations closer to the services they consume.

Had we decided to introduce a new service or component this would have
increased the effort required to operate the system and configuration
complexity. Operators were already not thrilled with the necessary
configuration for the system which made these options even less attractive.
The teams wanting to make the changes felt comfortable enough with this
approach that they contributed the new libraries that were needed.

Next time you are faced with a design decision like this consider whether
replacing a library, service or component would work for you.

<hr />

*I would like to thank [Michael Swart][swart] and Matt Campbell for helping
review this and several other early posts.*

[srp]: http://en.wikipedia.org/wiki/Single_responsibility_principle "A SOLID start"
[fowler]: http://martinfowler.com/articles/microservices.html
[micro]: http://highscalability.com/blog/2014/10/27/microservices-in-production-the-good-the-bad-the-it-works.html
[swart]: http://michaeljswart.com
