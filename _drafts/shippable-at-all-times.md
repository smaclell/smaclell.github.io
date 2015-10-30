---
layout: post
title:  "Being Shippable At All Times"
date:   2015-10-28 22:37:07
description: "Comparing and contrasting two approaches to being always shippable"
tags: releases builds process ci preflights shipping release
image:
  feature: nord-galaxy.jpg
  credit: Nord Galaxy by James Brooks CC BY 2.0
  creditlink: https://www.flickr.com/photos/jkbrooks85/7453384846/
---

In this post I explore two approaches to being shippable at all times;
knowing your Last Known Good package or having a Golden Master. Our team
thoroughly tracks our last good package we have built and tested. Other teams stay
shippable by keeping whatever is currently checked in stable. They can ship
their master branch and we can ship our Last Known Good package.

In order to ship software you need to do the following:

* Choose what to ship.
* Produce code worth shipping.

If your code is no good or always breaks the build then you will not have
anything to ship. You shouldn't choose to ship garbage.

By releasing something you implicitly choose what you want to ship. Often there
will be multiple builds/commits to choose from which could be shipped.

With solid Continuous Integration you can improve the confidence in each commit.
The confidence from great unit and acceptance testing can be enough to declare
any build shippable.

Lately, teams we work with have been intentionally trying to stay shippable.
They want to support releasing at any point and other Continuous Delivery
norms. Our team has long been trying to track the last package we deemed
shippable. Both approaches are effective and have their own trade-offs.

We focus on choosing what to ship based on previous good builds. It means we can always ship something when
we want to release. We keep track of the last build to be fully
tested, what went into it and where it has been deployed. From this
we choose our Last Known Good version. When it comes time to release
into production we ship that version.

The other teams focus on keeping their master branch shippable at all times. This
goes above and beyond keeping their Continuous Integration process green. No changes
can be merged which would prevent the code from releasing. Risky changes should be
broken down. When it is time to release the latest commit to the master branch is used.

Last Known Good
===============================================================================

<figure class="image-center">
	<img
		src="/images/lkg.jpg"
		alt="An image of various builds and commits highlighting the Last Known Good package">
	<figcaption>
		The Last Known Good package picked from the possible builds from the master branch.
	</figcaption>
</figure>

We track our last known good set of binaries through our deployment pipeline
and then choose which one set we want to ship at the end of the release. We
know exactly what went into each build and the testing which was performed.

With this approach there are few aspects which are really important:

* Knowing what has been committed to each build
* Tracking builds between different stages/validation
* Visibility into the deployment pipeline

What we ship is choice by our team supported by tracking what is in each build. If more
testing and validation is required we communicate with the team to make sure it
happens before we release. We closely follow which stories are included
in each build.

There is more communication overhead with this approach. The more people involved
with each releases the harder it is to agree on what the Last Known Good
is at any given point.

The current branch does not need to be perfect. Doing testing on the master branch is okay,
but needs to be coordinated. The worst case is master may be broken for short
periods. This can be dangerous for less
rigorous teams who may leave their code broken for days. It is still highly
recommended to use Continuous Integration and keep builds green.

Golden Master
===============================================================================

<figure class="image-center">
	<img
		src="/images/golden-master.jpg"
		alt="Multiple branches merged into a master branch. The tip is highlighted as the Golden Master">
	<figcaption>
		The Golden Master keeping the master branch shippable. Can always release the latest commit.
	</figcaption>
</figure>

Other teams focus on keeping their code shippable by ensuring the master branch
can always be built and deployed. For each commit, they ensure all integration tests
pass thanks to solid Continuous Integration. The majority of the deployment
pipeline is automated. More stability may be achieved using extra hardening phases.

Key aspects ensure the code remains stable by:

* Avoiding build break at all costs
* Extensive [preflights][preflights]
* More validation performed prior to merging

Changes requiring manual testing are problematic. They are inherently
not "always shippable" once they have been merged. Some teams compensate with even
more testing prior to merging to avoid breaking master. Others accept short
hardening periods to test all the code which has been committed.

I have worries about this approach and am biased to the Last Known Good. It seems
to be running well for teams using it, but can lead to problems due to delayed
merges. Since the emphasis is on staying stable changes can be delayed or avoided.
Refactoring is harder if teams merge less frequently. Teams need to focus on
merging small changes frequently. Another great mitigation is to merge sooner and
keeping risky code behind feature flags for later testing. It is imperative to
avoid merging ALL THE CHANGES at the end of a release cycle.

Choosing what to ship is easy. Use the latest commit. No need to get fancy
picking which build or tracking what has happened.

Risk
===============================================================================

All releases have risks. Whether the risks are technological or business-related it
does not matter. Every change includes some element of uncertainty. Both Last
Known Good and Golden Master strategies address the risks associated with
releases but approach the problem differently.

The Last Known Good approach builds in accounting for risk in how you choose
which version to use. Picking which builds are good could be a factor of
automated testing, selection by testers, voting by a group of people, etc.
Business pressure to release something too soon can cause issues to be shipped
to production.

Gaps in automation indicating whether or not master is broken reduce the
effectiveness of the Golden Master. As with any CI process, they are only as
good as the coverage they provide. Risk can be reduced with an extra
hardening period or intermediate branches, but this pushes the problem
to that location and introduces delays.

Both approaches suffer from issues with the validation used to determine good
versions and stop bad versions. If the version choice or validation are incomplete
then bad versions will sneak through.

Next Step: Going Continuous
===============================================================================

If you take both approaches to the limit you end up at Continuous Delivery and
Continuous Deployment. Shipping more frequently and being ready to release at
any moment.

With Continuous Delivery it is important to be able to release at any point. What
and when to release is chosen based on needs and features. It is essential to
do comprehensive testing in development by deploying to production-like environments.
The deployment process and configuration should be automated. This is close to
our Last Known Good approach with a great emphasis on being deployment ready.
The Golden Master can easily be used the same way since every commit should be
shippable.

Continuous Deployment takes Continuous Delivery further. Every build which
passes automated testing is automatically deployed into production.
It is what you would get if after you tested your Golden Master you deployed
every passing build into production.

To know gauge how continuous your process is you can use this test from [Martin Fowler][fowler-test]:

> The key test is that a business sponsor could request that
> **the current development version of the software can be deployed into production at a moment's notice**
> - and nobody would bat an eyelid, let alone panic.

Both our team and others are trying to do Continuous Delivery. We
make potential releases all the time and then choose when we want to ship based
on our client needs. Earlier this year we [accelerated our releases][boring] and
do full Continuous Deployment into some environments. Releasing more often has
been fantastic and lets us react to changes more effectively.

So far our focus in this blog post has been on everything leading up to a final
release into production. Improving your release process and
shipping continuously is the logical next step.

Don't stop at being shippable; keep going for Continuous Delivery or Continuous
Deployment.

For a more thorough description of each term see this fantastic Stack Overflow
question: [Continuous Integration vs. Continuous Delivery vs. Continuous Deployment][ci-cd-cd]

Why Not Both?
===============================================================================

These two options don't compete with one another. They complement one another.
You can happily do them both at the same time. Emphasizing shifts what to
prioritize when improving your deployment pipeline.

By applying both approaches together, you increase your odds of having
great releases. You can ship more. You will have higher confidence in each
release. The closer you get to a Golden Master branch you will have many
Last Known Good builds to choose from.

The more thorough your automated validation, the more confidence you have
in each build you make. Reduce the overhead and effort for each release.
Keep improving your releases and try Continuous Delivery or Continuous
Deployment.

Choose the best from each approach and apply it to your deployment pipeline.
Then get to work shipping great software.

[preflights]: {% post_url 2015-09-29-preflights-changed-our-world %}
[fowler-test]: http://martinfowler.com/bliki/ContinuousDelivery.html
[boring]: {% post_url 2015-01-28-deploys-becoming-boring-part-3 %}
[ci-cd-cd]: http://stackoverflow.com/questions/28608015/continuous-integration-vs-continuous-delivery-vs-continuous-deployment
