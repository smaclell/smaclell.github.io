---
layout: post
title:  "Deploys Becoming Boring - Part 2: Iterating"
date:   2014-09-22 23:11:07
tags: deployment process series
---

In order to make releases smooth what happened? What changes did we make and what
did we learn? This is the story about how releases changed over time and became
what they are today.

It wasn't always easy for us to promote our code. It took time and effort to
get there and a whole lot of iterating. This is our story about how over the
course of a few weeks we were able to go from a system with little confidence
to smooth regular updates that are downright boring.

{% include series/deploys-becoming-boring.html %}

Going Weekly
---------------------------------------

Deploying weekly was not smooth at first but soon became much better. We still had alot
of habits from our early deployments which resulted in some bad behaviour. In
the first two updates we tried to cram more new functionality into the releases
at the last minute. This was a risky proposition given our track record and
client confidence but we wanted to get more shipped! This resulted in back to
back [brown paper bag][bag] releases that need to be patched right away.
Luckily these issues we caught by our smoke tests and thanks to the existing
deployment pipelines were reproduced and fixed immediately.

From these initial hiccups we started to catch our stride. We spent more time
fixing defects and stabilizing the system. As we got into a rhythm the releases
became less important as we could easily wait for the next one and so the old
habits and stress of big releases faded. By the third deployment we had
polished the promotion process so that is was a single click for each service.
As things became easier we started to rotate the team members doing the
updates to share the knowledge more widely and further refine our efforts.

We decided to up the ante by doing Continuous Deployment in our Dev
environment. When releases passed sufficient testing they were automatically
deployed and the necessary high fives performed! Each commit would kick off
this cycle and so new deployments happened all of the time during active
development. There was so little overhead to each release that we barely
noticed that they were happening except for flashing colours on our dashboard.
This pressured us to automate even more of the feedback process so that no
human intervention was required.

Manual deployments quickly became a thing of the past. We extended our scripts
used in the Dev environment to deploy to any other environment. This simplified
the process and made it easy enough for more people perform updates.
We problems were found they would be fixed immediately which helped make them
more robust and resilient. By continuously exercising these scripts we became
very confident they would work as intended.


Testing
---------------------------------------

As part of [The Agreement](TODO#the-agreement) we instituted more comprehensive
smoke testing. We verified that entire system could perform the most critical
operations. This was done with our clients to share the new releases with them
and collaborate more.

In our Dev environment we bolstered our testing with more scenarios that
covered the use cases that our clients cared about the most. This started as
manual acceptance testing near the end of each release that was time consuming
and onerous. Week by week we automated this process so that it was no longer a
final stamp on each release but was triggered by every commit as part of the
deployment pipeline to act as release acceptance tests. Once fully automated,
we could be very confident in each change that was being made to the system
and validate new releases faster than ever.

TODO: Talk about these tests running more often to find environmental problems

The testing forms two levels, the individual services then fully integrated.

First commit tests run to verify the basic functionality at the lowest level.
These are not all unit tests so that we could verify the most important parts
of each component as early as possible. Next we typically deploy that service
in isolation, execute smoke tests and then run acceptance tests. These tests
are more complicated and cover larger portions of the system. They still try to
isolate each service but can include other stable collaborators as needed.

<p class="center-image">
	<img
		title="One little service building in a row."
		alt="A single pipeline with a commit state, acceptance stage and finally a deploy"
		src="/images/posts/SimplePipeline.png" />
</p>

We then update the changed service(s) followed by running the release acceptance
tests to comprehensively verify the new changes. Where possible we try to keep
the other services unchanged so failures can be attributed to the changes.
This has been instrumental at finding subtle system level integration issues.
Occasionally, we would perform some manual testing for areas particularly hard
to check automatically or would provide limitted use. We try very hard to
automate all of our testing and reduce what needs to be verified manually.

<p class="center-image">
	<img
		title="Three little service building in a row."
		alt="A three pipelines then integrated testing followed up by shipping!!"
		src="/images/posts/PipelineFunnel.png" />
</p>

Commits trigger the individual deployment pipelines which are responsible for
the commit and acceptance tests. Once each pipeline is complete they trigger
the release acceptance tests. This exercises all changes early and often so that
we receive feedback right away.

The Effects of Speed
---------------------------------------

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
consideration and needed extra testing/development effort. Although more work
was required to keep the code stable we were able to ship new functionality
sooner and with less ceremony. Earlier delivery meant better feedback on new
features which helped guide future changes. Breaking changes took more time and
often spanned multiple releases so there was always a smooth transition. This
tradeoff was routinely frustrating but we persisted because it helped us make a
better product and allowed our users adopt new releases sooner.

Conclusions
---------------------------------------

We were now able to consistently add new functionality and improve the
capabilities of the system safely. We started building things smaller, more
backwards compatible and our quality went up. By investing in changes to
stablize the system we were able to radically improve how we ship software.

[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[pipeline]: http://martinfowler.com/bliki/DeploymentPipeline.html
[bag]:      http://www.catb.org/jargon/html/B/brown-paper-bag-bug.html
