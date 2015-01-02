---
layout: post
title:  "Deploys Becoming Boring - Part 1: In the Beginning"
date:   2014-09-22 23:11:07
tags: deployment process series
---

It wasn't always easy for us to promote our code. Releases were deadlocked and
our clients were not confident about they would work. This first part outlines
the status quo before we started to change our release process. This is our story
about how over the course of a few weeks we were able to go from a system with
little confidence to smooth regular updates that became downright boring.

{% include series/deploys-becoming-boring.html %}

In The Beginning
---------------------------------------

We started our project with large releases. This was not how we wanted it
to be but it was how things ended up. Promoting each release turned into a
serious event whenever the deployment window opened up. We had all the
ceremony, fear and pressure to make our dates that are cited as delivery
anti-patterns by the [Continuous Delivery][cd] book.

> ... quick hacks to get newly deployed production systems running
> weren't being driven by such immediate commercial imperatives, but rather by
> the more subtle pressure to release on the day that was planned. The problem
> here is that releases into production are big events. As long as this is true
> they will be surrounded with a lot of ceremony and nervousness.
>
> <cite>Page 20 of [Continuous Delivery][cd]
> by [Jez Humble][jez] and [Dave Farley][dave]
> </cite>

Our software worked as advertised but had intermittent issues for some clients.
This discouraged these clients from taking new
releases. This caused a catch-22 prevented us from releasing new version that
fixed the issues which made problems worst and meant issues went unsolved
longer. Other software used with our continued to change in ways that forced us
to create small forks in the code to add new functionality against the old
releases instead of
shipping a new fixed version. Needless to say these forks were not what we
wanted to do long term and were a stop gap for our clients.

Many problems centered on environment instability. Our favourites
were running out of disk space or IP addresses that would prevent the running
system from continuing to function. We had one big set of hardware for every environment
and so any misbehaving environment would take resources from its neighbours. This was
particularly troublesome with our Dev, QA and Certification (Cert) environments which received
updates sequentially and failing in one environment prevented progressing to
the next one. Our clients who cared the most about QA and Cert would be
impacted when Dev is running larger tests that take lots of resources.

<p class="image-center">
	<img
		title="All the ducks in a row"
		alt="Our three main ecosystems, Dev to QA to CERT"
		src="{{ site.url }}/images/posts/Ecosystems.png" />
</p>

Another unfortunate consequence of sharing infrastructure between environments
was normal changes could have unintended side effects. Dev, QA and CERT are
internal environments and do not have formal change management processes.
Reconfiguring a network in QA might break Dev. Routine cleanup could remove
important records for a neighbouring environment. These open changes further
reduced our stability and reliability.

Early in the development process small groups of developers on our team were
able to work together on individual services that compose the overall system.
While this was great for getting things done at the beginning of the project it
formed mini silos around each service. Deploying new versions would mean
getting the original developers to work their magic and ship the new update.

We had competing goals with some of our clients. They needed stability
whereas we needed to introduce and validate new functionality. Our ability to
produce new tested software vastly out stripped the rate that it was being
consumed downstream. We had been behaving like we could deploy changes the
second they were done but this was not reality beyond the Dev environment.
One of our clients described us as a rocket strapped to a steam engine.

<p class="image-center">
	<a href="http://pixabay.com/en/rack-railway-locomotive-tracks-174363/">
		<img
			title="Full Speed Ahead! Courtesy of Pixabay"
			alt="An open rail track going off into the distances beside an old steam engine"
			src="{{ site.url }}/images/posts/rack-railway-174363_640.jpg" />
	</a>
</p>

We wanted to do better. We wanted to break this deployment deadlock and
accelerate the rate at which we could release with confidence.

The Agreement
---------------------------------------

In order to speed up we realized that we first needed to slow down. Going as
fast as we could was no good if clients did not receive our updates. Slowing down
would also mean investing more into stability, testing and validation for each
change which would improve the feedback on each release.

After discussing how to improve the current situation decided we wanted to
deploy as part of a normal cycle that would happen fairly often. For us the
ideal was always immediately after a commit has passed through normal testing but
given our track record that remained a dream. We wanted a speed that would
make things routine, provide feedback early/often and stretch the organization
to achieve it by being faster than the norm but not too painfully fast.

There is a common agile adage that "if it hurts, do it more often". By
feeling the pains in our release process we would learn firsthand what our
biggest hurdles were and it would force us to address them head on. Bottling
up changes in large releases months away meant we could work around them or
accept subpar work instead of dealing with the root cause.

We wanted to improve the confidence in our releases. We thought the easiest way
to rebuild confidence would be to have fewer issues and provide more
opportunities for validation. The defects experienced by our clients were a big
issue for them and were a focal point of our conversations together. Improving
our consistency and quality was naturally an imperative.

We had been using [Deployment Pipelines][pipeline] to validate our software as we
built it. This helped us feel confident that we could ship more frequently and
improve quality at the same time. What was lacking in this feedback loop were
tests that could prevent the types of defects being reported.

In order to reduce the ceremony around releases we wanted to change how they
were documented. We had been trying to be very lean by including little to no
documentation but we were being asked for extensive manuals and walkthroughs.
We felt that there was a workable compromised somewhere in the middle. We
thought that clear and transparent communication would help improve our
relationship.

With our clients, we then struck the following agreement to improve the
situation and enable us to ship:

1. Regular Weekly Deployments
1. More Testing
1. Documented Changes

In the next installment we will explain how the story unfolds and what changed
to get better at releasing with confidence.

<hr />

*I would like to thank [Michael Swart][swart], Matt Campbell and Bogdan Matu
for helping review this and several other early posts.*

[jez]:      https://twitter.com/jezhumble
[dave]:     https://twitter.com/davefarley77
[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[pipeline]: http://martinfowler.com/bliki/DeploymentPipeline.html
[swart]:    http://michaeljswart.com
