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
thoroughly tracks our last good build/deploy/version. Other teams stay
shippable by keeping whatever is currently checked in stable. They can ship
their master branch and we can ship our Last Known Good package.

In order two ship software you need to do the following:

* Choose what to ship.
* Produce code worth shipping.

If your code is no good or always breaks the build then you will not have
anything to ship. You shouldn't choose to ship garbage.

By releasing something you implicitly choose what you want to ship. Often there
will be multiple builds/commits to choose from which could be shipped.

With solid Continuous Integration you can improve the confidence in each commit.
The confidence from great unit and acceptance testing can be enough to declare
any build shippable.

Lately teams we work with have been intentionally trying to stay shippable.
They want to support releasing at any point and other Continuous Delivery
norms. Our team has long been trying to track the last package we deemed
shippable. Both approaches are effective and have their own trade-offs.

We focus on choosing what to ship. It means you can always ship something when
you want to release. It is more important for us to know exactly what is in each
build and how it has been tested. We keep track of the last build to be fully
tested, what went into it and the environments it has been used in. From this
we determine what our Last Known Good version. When it comes time to release
into production we ship that version.

The other teams focus on keeping their master branch shippable at all times. This
goes above and beyond keeping your Continuous Integration process green. No changes
can be merged which will hold you back from releasing. Risky changes should be
broken down. When it is time to release the latest commit to the master branch is used.

Last Known Good
===============================================================================

We track our last known good set of binaries through our deployment pipeline
and then choose which one set we want to ship at the end of the release. We
know exactly what went into each build and the testing which was performed.

With this approach there are are few aspects which are really important:

* Tracing inputs
* Tracking builds between different stages/validation
* Visibility into the deployment pipeline

What we ship is a human choice supported by our tracking. If more
testing/validation is required we communicate with the team to make sure it
happens before we release. We closely follow which stories have been merged and
make it into each build.

There is more communication overhead and if there were more people involved
with the releases it would be much harder to agree on what the Last Known Good
is at any given point.

The current branch does not need to be perfect. This can be dangerous for less
rigorous teams who may leave their code broken for days. It is still highly
recommended to use Continuous Integration to stay stable.

Golden Master
===============================================================================

Other teams focus on keeping their code shippable by ensuring the master branch
can always be built/deployed. For each commit we ensure all integration tests
pass thanks to solid Continuous Integration. The majority of the deployment
pipeline is automated or part of later stability phases.

Key aspects ensure the code remains stable by:

* Avoiding build break at all costs
* Extensive [preflights][preflights]
* More validation performed prior to merging

Changes requiring manual testing are problematic. They violate are inherently
not "always shippable" once they have been merged. Some teams try to do even
more testing prior to merging to avoid polluting master. Others accept short
stabilization periods to test all the code which has been committed.

Assuming everyone is committing to master frequently then your team will create
many potential releases. Choosing which one is easy and can be the latest build
at a given point. No need to get fancy picking which build or tracking what has
happened.

Overhead and Delays
===============================================================================

Each model has a different tendency to introduce overhead and delays. Overhead
makes releases more expensive and challenging. Delays slow down the feedback
teams get from releasing frequently.

#### LKG

**More tracking is required.** Tracking the Last Known Good takes
effort. Understanding what is in each build and why they are good/bad is more
work than using the Golden Master. This can be simplified by building it into
your deployment pipeline.

**Potential communication and process overhead.** Depending
on how you determine the Last Known Good version there may be more communication
and overhead. If you need to coordinate across many teams or have manual signoff
it will add to the delays.

**Unstable builds add delays.** Teams who do not keep their builds stable will
have a harder time with having enough Last Known Good versions. If no version
is readily available and it is time to release teams may have more delays while
they try to find what to ship.

#### Golden Master

**Delays occur before merging.** Unlike the Last Known Good, the Golden Master
approach the delays are encounter prior to merging the code. Additional
preflights and stabilization branches increase the amount of time before code
is merged. The added testing to ensure the change is ready to be shipped
further slows down merging. Using feature flags and more automated validation
can mitigate the added delays.

**Small changes can be discouraged.** Since every change touching master must
be perfect teams often avoid making small changes. After all every change is a
risk. This line of thinking is actually a fallacy and increases the risk of
each change. The recommendation is to focus on making smaller changes safe and
frequently merge. At all costs, avoid the anti pattern of merging many branches
at near the end of a release.

**Delayed integration increases risks and prohibits refactoring.** The added
time prior to merging can cause delayed integrations. The longer these delays
are the more impact they can have on normal programming. Refactoring can cause
more merge conflicts than normal. The longer a refactoring waits before being
merged the higher the likelihood of other changes conflicting with it. Normal
changes can also be broken by other branches which are inflight. It is better
to merge more often and allow other code to build on each other.

Risk
===============================================================================

All releases have risk. Whether the risk is for the technology or business it
does not matter. Every change includes some element of uncertainty. Both Last
Known Good and Golden Master strategies address the risks associated with
releases, but approach the problem differently.

The Last Known Good approach builds in accounting for risk in how you choose
which version to use. Picking which builds are good could be a factor of
automated testing, selection by testers, voting by a group of people, etc.
Business pressure to release something too soon can cause issues to be shipped
to production.

Gaps in automation indicating whether or not master is broken reduce the
effectiveness for the Golden Master. As with any CI process, they are only as
good as the coverage they provide. Risk can be reduced with an extra
stabilization period or intermediate branches, but this pushes the problem
to that location and introduces delays.

Both approaches suffer from issues with the validation used to determine good
versions and stop bad versions. If the validation is limited then bad versions
will sneak through.

Going Continuous
===============================================================================

If you take both ideas to the limit you end up at Continuous Delivery and
Continuous Deployment. They are very similar and focus on taking your code into
production.

Continuous Delivery is where you create potential releases all the time. You
can deploy your code in development to production-like environments for
comprehensive testing. You then choose which release to deploy. This is in
essence our Last Known Good including the deployment process. You could take
it further an include a big button to deploy into production what you have made.
Press the button often. Always be able to ship.

Continuous Deployment deploys every build into production which passes through all the
automated testing and validation. It is what you would get if after you tested
your Golden Master you deployed every passing build into production. The button
has been removed and releases are automatically deployed.

To know gauge how continuous your process is you can use this test from [Martin Fowler][fowler-test]:

> The key test is that a business sponsor could request that
> **the current development version of the software can be deployed into production at a moment's notice**
> - and nobody would bat an eyelid, let alone panic.

So far our focus in this blog post has been on everything leading up to a final
release which is shipped to production. Improving your release process and
shipping continuously is the logical next step.

What both our team and others are doing is closer to Continuous Delivery. We
make potential releases all the time and then choose when we want to ship based
on our client needs. Earlier this year we [accelerated our releases][boring] and
do full Continuous Deployment into some of our environments.

For a more thorough description of each term see this fantastic Stack Overflow
question: [Continuous Integration vs. Continuous Delivery vs. Continuous Deployment][ci-cd-cd]

Why Not Both?
===============================================================================

These two options don't compete with one another. The complement one another.
You can happily do them both at the same time. They shift what you will emphasize.

By applying both approaches at the same time you increase you odds of having
great releases. You can ship more. You will have higher confidence in each
release. The closer you get to a golden master branch you will have many
last known good builds to choose from. The more thorough your automated
validation the more confidence you have in each build you make.

Choose the best of each approach you want to apply to your deployment pipeline.
Then get to work shipping great software.

[preflights]: {% post_url 2015-09-29-preflights-changed-our-world %}
[fowler-test]: http://martinfowler.com/bliki/ContinuousDelivery.html
[boring]: {% post_url 2015-01-28-deploys-becoming-boring-part-3 %}
[ci-cd-cd]: http://stackoverflow.com/questions/28608015/continuous-integration-vs-continuous-delivery-vs-continuous-deployment
