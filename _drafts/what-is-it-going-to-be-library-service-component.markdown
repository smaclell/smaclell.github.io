---
layout: post
title:  "What is it going to be? Library, Service or Component!"
date:   2014-10-01 23:35:07
categories: development design craig
---

Take Away
=======================================

Consider what level or where you are trying to design for and the accompanying
tradeoffs.

The Problem: New Design Constraints
=======================================

A few weeks ago we had an interesting team discussion about how best to
introduce a series of changes to a system we maintain. The system is fairly
complicated with a variety of moving pieces. Each piece typically has one
responsibility and are very specialized. The overall system performs a limited
set of operations in one and only one way. This was a choice that we made early
on that lead to more coupling overall with the goal of being simpler by
focusing on the needs at the time.

In a few areas we decided to create small services to perform long running
tasks or interact with other complex software. We spent a bit of time up front
determining generic APIs for each service so that this would be a potential
avenue to augment the system in the future. These services isolate operational
complexity and provide users a way to manage the system within each service.
The domain we are working in can provide a great deal of configuration which
would lead to horrible complexity and difficulty to use if left unchecked.
This meant we hid most that complexity/configuration behind the service API and
adjust setting on each service independently. Manage our configuration this way
hasn't all been a bed of roses but we will come back to that in a different
post.

We were approached by another team who wanted to extend our system so that they
could perform some of the operations in a different way. The new extensions
would be similar to the existing pieces but different enough that it put new
stress on our design. Think gala apples to granny smith apples instead of
apples to oranges. Our problem was where to make the change to our system.

The Idea: Library, Service or Component!
=======================================

In talking to my boss, Craig, about the problem and we came up with 3 places we
could swap in the new functionality. These 3 places a single library, a
complete service or configuring a new component within an existing service.

<p class="center-image">
	<img
		title="Yes, this image was made using paint."
		alt="The three places to make the change, i.e. library, service or component"
		src="/images/posts/LibraryServiceOrComponent.png" />
</p>

Each of these options present different trade-offs. Regardless of the approach
the complexity of that area will increase, i.e. using a different service
increases the dependence on service's API. The options provides differing code
isolation and maintainability challenges. Adjusting the library has the lowest
operating cost but has the highest impacting to the existing running code
especially if multi-libraries are used. Changing the service or underlying
components are natural extension points within a system like this but would
likely add to our configuration complexity.

Conclusion
=======================================

In the end we decided to swap out individual libraries. While this did
represent additional refactoring it helped to greatly improve the clarity of
the design while reducing the coupling to the existing operations. We then
wrapped up small client libraries for each service to isolate how they are
used. In the end we tried to minimize the changes needed by our clients so that
they would not need to do any work to take advantage of the new implemention.
Had we decided to introduce a new service or component this would have
increased the work required to operate the system and so we decided against
that path.

Next time you are faced with a design decision like this consider swapping a
library, service or component.
