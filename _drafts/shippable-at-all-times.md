---
layout: post
title:  "Being Shippable At All Times"
date:   2015-09-29 22:37:07
tags: releases builds ci preflights shipping release process
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
norms. Our team has long been trying to have small shippable iterations so we
can be more effective.

TODO: Read these paragraphs. Decide if I should add more connector and fold them into their sections.

We focus on choosing what to ship. It means you can always ship something when
you want to release. It is more important for us to know exactly what is in each
build and how it has been tested. We keep track of the last build to be fully
tested, what went into it and what environments it has been used in. From this
we determine what our Last Known Good version. When it comes time to release
into production we ship that version.

Other teams focus on keeping their master shippable at all times. This goes
above and beyond keeping your Continuous Integration process green. No changes
can be merged which will hold you back from releasing. Risky changes are avoid.
When it is time to release the latest commit to the current branch is used.

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

Tracking the Last Known Good takes effort. This can be reduced through automation.

LKG

- Overhead is from communication and process. Automate it out.
- Tolerating frequent failures slows down merging
- Delays are when you approach releasing


GM

- Disincentives small changes. It has to be perfect right?
- Delays integration which makes refactoring harder
- Delays are before merging

So what is the big deal? Forcing teams to always have perfect master branch
puts much more pressure on every change. Everything must be perfectly tested
and validated before you can even consider merging it. This shifts the
mentality from small bite-sized changes to complete features which tend to all
flood in at the last minute.

On the contrary if master can be unstable or not perfect to release you can
plan your work differently. It becomes okay to merge little pieces instead of
complete feature. If it makes sense you defer manual testing a little bit
later. You might not want to ship the current changes and that is okay. Once
the changes are manually validated you can decide which package is ready.

Risk
===============================================================================

All releases have risk. Whether the risk is for the technology or business it
does not matter. Every change includes some element of uncertainty. Both Last
Known Good and Golden Master strategies address the risks associated with
releases, but approach the problem differently.

LKG

- Acknoledges risk is how it is formulated. Only as good as the formulation

GM

- Risk comes from gaps in automated validation and how extra stabilization happens


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
on our client needs. Early this year we [accelerated our releases][boring] and
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
