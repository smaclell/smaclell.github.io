---
layout: post
title:  "Deploys Becoming Boring - Part 2: Iterating"
date:   2014-09-22 23:11:07
tags: deployment process series
---

In order to make things easy what happened? What changes did we make and what
did we learn? This is the story about how things changed over time and became
what they are today, downright boring.

{% include series/deploys-becoming-boring.html %}

Going Weekly
=======================================

Deploying weekly was not smooth at first but soon became much better. We still had alot
of habits from our early deployments which resulted in some bad behaviour. In
the first two updates we tried to put more new functionality into the releases
at the last minute. This was a risky proposition given our track record and
client confidence but we wanted to get more shipped! This resulted in back to
back [brown paper bag][bag] releases that need to be patched right away.
Luckily these issues we caught by our smoke tests and thanks to the existing
deployment pipelines were diagnosed then fixed immediately.

From these initial hiccups we started to catch our stride. We spent more time
fixing defects and stabilizing the system. As we got into a rhythm the releases
became less important as we could easily wait for the next one and so the old
habits and stress of big releases faded. By the third deployment we had
polished the promotion process so that is was a single click for each service.
As things became easier we started to rotate the team members doing the
updates to share the knowledge more widely and further refine our efforts.

Testing
=======================================

As part of [The Agreement](TODO#the-agreement) we instituted more comprehensive
smoke testing. We verified that entire system could perform the most critical
operations. This was done with our clients to share the new releases with them
and collaborate more.

In our dev environment we bolstered our testing with more scenarios that
covered the use cases that our clients cared about the most. This started as
manual acceptance testing near the end of each release that was time consuming
and onerous. Week by week we automated this process so that it was no longer a
final stamp on each release but was triggered by every commit as part of the
deployment pipeline. Once fully automated we could be very confident in each
change that was being made to the system and certify new releases faster than
ever.

The testing forms two levels, the individual services then fully integrated.

First commit tests run to verify the basic functionality at the lowest level.
These are not all unit tests so that we could verify the most important parts
of each component as early as possible. Next we typically deploy that service,
smoke test it then run a series of acceptance tests. These are more complicated
and test larger portions of the system. They still try to isolate each service
but can include other stable collaborators as needed.

<p class="center-image">
	<img
		title="One little service building in a row."
		alt="A single pipeline with a commit state, acceptance stage and finally a deploy"
		src="/images/posts/SimplePipeline.png" />
</p>

We then run the automated manual acceptance tests to comprehensively verify the
new changes while keeping the rest of the system stable. This second level of
end to end testing makes it easy to find issues introduced by the new changes
affecting the rest of the system. Occasionally, we would perform some manual
testing for areas particularly hard to test automatically or of limitted use.
Due to the coverage of the automated testing we rarely need more manual
testing and try hard to automate it whenever possible.

<p class="center-image">
	<img
		title="Three little service building in a row."
		alt="A three pipelines then integrated testing followed up by shipping!!"
		src="/images/posts/PipelineFunnel.png" />
</p>

Commits trigger the individual deployment pipelines which are responsible for
the commit and acceptance tests. Once each pipeline is complete they trigger
the final integration tests. This exercises all changes early and often so that
we receive feedback right away.

The Effects of Speed
=======================================

Each new issue that came up was dealt with immediately and then more permanent
fixes were put into place to prevent them from occuring again. This included
more monitoring and diagnostics which enabled us to find and deal with issues
before they hindered the services we had created. We invested further into
hardenning our environments and isolating the different resources used by each
one. This prevented the cross contamination we were seeing and vastly improved
the environment stability. Thanks to weekly releases our clients would get the
changes right away instead of having to wait weeks for fixes to be deployed.

Another interesting side effect occurred as we continued this process. Early on
the changes were quite large but eventually shrunk much smaller. The acclerated
releases meant that we could no longer do large sweeping changes to the system
and instead needed to think about how they could be introduced incrementally.
By having small changes it was easier to get the quick feedback we wanted while
keeping the entire system stable. Smaller incremental changes continued to
improve the quality of our releases.

With such frequent releases meant that releases were always on our mind. Every
change we introduced needed to be consider how it would impact the deployment
and our users. Backwards compatiblity became a very important design
consideration. Overall I feel like this slowed down how fast we could make some
changes but deliver new functionality sooner with less effort for our users.
Since we could deliver earlier we received better feedback on new features
which helped us make more effective changes. However, the downside is code that
could have been removed quickly with a breaking change now needed to be planned
over multiple releases. This tradeoff was routinely frustrating but we
persisted because it helped us make a better product and was easier for our
users.

Conclusions
=======================================

We were now able to consistently add new functionality and improve the
capabilities of the system safely. We started building things smaller, more
backwards compatible and our quality went up. By investing in changes to
stablize the system we were able to radically improve how we ship software.

[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[pipeline]: http://martinfowler.com/bliki/DeploymentPipeline.html
[bag]:      http://www.catb.org/jargon/html/B/brown-paper-bag-bug.html
