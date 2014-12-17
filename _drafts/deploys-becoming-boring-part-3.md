---
layout: post
title:  "Deploys Becoming Boring - Part 3: Boredom and the Future"
date:   2014-09-22 23:11:07
tags: deployment process series
---

Deployments are now longer an event. Routine has taken over. We like this
stress free future we have built. We can now sit back to see where we are
and choose where want to go next.

{% include series/deploys-becoming-boring.html %}

Routine Again
---------------------------------------

It has now been almost half a year of doing weekly updates and they have blended
into our usual routine. What was once a scary proposition has become
common place. Each good update reinforces a cycle of success
that continues to build confidence and trust. We no longer need days to deploy
updates using a process known to only a few team members; instead anyone can
release an update in minutes with a single button. Our deployments are no
longer big events thanks to how often they are practiced successfully.

> After you have deployed a complex system for the fiftieth or hundredth time
> without a hitch, you don't think about it as a big event any more.
>
> <cite>Page 130 of [Continuous Delivery][cd]
> by [Jez Humble][jez] and [Dave Farley][dave]
> </cite>

Our testing and release management have helped us create better releases. Now
when a defect is found it is unusual and often can be mitigated or rolled back.
Fixes can be easily introduced, tested and shipped instead of hindering our
clients for weeks. There are no forks of the codebase and all our momentum is
directed forward. We have been able to sustain rapid development for months and
continue to evolve the entire system safely.

Environmental issues are infrequent and less impactful. We know well in advance
if there maybe issues in the future and can address them proactively. Working
together with our clients we understand what is happening in the environments
and can accomodate larger changes. Environments do not impact each other with
regular activity.

The biggest change has been how our stakeholders view the whole process. Once
apprehensive about updates they have now become some of our biggest advocates.
Lately, they have wanted changes faster than ever before. They trust our
Deployment Pipeline to validate small changes and are willing to accelerate.
The way we work together and talk about what is happening are night and day
from low confidence before to fully supporting each other now.

Our clients who were most resistant to change we have started to
collaborate on larger projects together. Savy members of their team have sent
pull requests and other patches to smooth out their workflows. Not only are the
fixes we are doing for them making the process go smoother they are adding new
functionality to address their needs where we have not been able to. This is
very exicting and I hope we can continue to encourage this behaviour.

Next
---------------------------------------

To build on our success it is time for the next step.

> It should be possible to deploy a single change
> to production through the deployment pipeline with the minimum possible time
> and ceremony. The release process should be continuously evaluated and
> improved, identifying any problems as close to the point at which they were
> introduced as possible.
>
> <cite>Page 130 of [Continuous Delivery][cd]
> by [Jez Humble][jez] and [Dave Farley][dave]
> </cite>

We want to take our continuous deployments in the Dev
environment and start doing the same thing in our QA environment. For everything else
downstream we want to drasticly reduce the delays that are currently present.
This will potentially double the rate we can ship changes by shortenning the time
required before getting to production.

Our future looks promising and we will continue to iterate on our problems. We
have come a long way since we first started but there are still more
oppertunities. Simple changes will be able to ship much faster and be useful
right away. With more effort we can achieve the bare minimum required to ship any change.
Defects can be fixed faster. Features done more safely. Our software can keep
evolving.

*I would like to thank [Michael Swart][swart], Matt Campbell and Bogdan Matu
for helping review this and several other early posts.*

[jez]:      https://twitter.com/jezhumble
[dave]:     https://twitter.com/davefarley77
[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[swart]:    http://michaeljswart.com
