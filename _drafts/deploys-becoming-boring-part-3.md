---
layout: post
title:  "Deploys Becoming Boring - Part 3: Boredom and the Future"
date:   2014-09-22 23:11:07
tags: deployment process series
---

Deployments are now longer an event. Routine has taken over. Where are we going
next and why. We like this stress free future we have built and can now sit
back to see where we are.

{% include series/deploys-becoming-boring.html %}

Routine Again
=======================================

It has now been almost half a year of doing weekly updates and the updates have
become part of the usual routine. What was once a scary proposition have become
common place. With each successful update we have reinforced a cycle of success
that continuess to build more confidence and trust. We no longer need days to
deploy updates for select members of our team and instead anyone can do release
something new. As shown in the quote below our deployments are no longer a big
event.

> After you have deployed a complex system for the fiftieth or hundredth time
> without a hitch, you don't think about it as a big event any more.
>
> <cite>Page 130 of [Continous Delivery][cd]
> by [Jez Humble][jez] and [Dave Farley][dave]
> </cite>

The biggest change has been how our stakeholders view the whole process. Once
apprehensive about updates they have now become some of our biggest advocates.
Lately, they have wanted changes faster than ever before. They trust our
Deployment Pipeline to validate small changes and are willing to accelerate.
The way we work together and talk about what is happening are night and day.

For our clients who were most resistant to change we have started to
collaborate on larger projects together. Savy members of their team have sent
pull requests and other patches to smooth out their workflows. Not only are the
fixes we are making for them making the process go smoother they are adding new
functionality to address their needs where we have not been able to. This is
very exicting and I hope we can continue to encourage this behaviour.

Next
=======================================

It is time for next step. We want to start doing full continuous delivery to
some of the earlier parts of our pipeline so that every successful commit is
deployed automatically. For everything else downstream we want to drasticly
reduce the delays that are currently present. This will potentially double
the rate we can ship changes by shrinking the time required before getting to
production.

> If we want to be wholly confident in the release process and the technology,
> we must use it and prove it to be good on a regular basis, just like any
> other aspect of our system. It should be posssible to deploy a single change
> to production through the deployment pipeline with the minimum possible time
> and ceremony. The release process should be continuously evaluated and
> improved, identifying any problems as close to the point at which they were
> introduced as possible.
>
> <cite>Page 130 of [Continous Delivery][cd]
> by [Jez Humble][jez] and [Dave Farley][dave]
> </cite>

Our future looks promising and we will continue to iterate on the problem. We
have come a long way since we first started but there are still many more
oppertunities. Simple changes will be able to ship much faster and be useful
right away. With more effort we can get to the bare minimum to ship any change.
Defects can be fixed faster. Features done more safely. Our software can keep
evolving.

[jez]:      https://twitter.com/jezhumble
[dave]:     https://twitter.com/davefarley77
[cd]:       http://www.amazon.com/dp/B003YMNVC0/
