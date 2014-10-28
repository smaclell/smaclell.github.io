---
layout: post
title:  "Deploys Becoming Boring - Part 1: In the Beginning"
date:   2014-09-22 23:11:07
tags: deployment process series
---

It wasn't always easy for us to promote our code. It took time and effort to
get there and a whole lot of iterating. This is our story about how over the
course of a few weeks we were able to go from a system with little confidence
to smooth regular updates that are downright boring.

{% include series/deploys-becoming-boring.html %}

In The Beginning
=======================================

We started out our project with large releases. This was not how we wanted it
to be but this is how things ended up. Promoting each release turned into a
serious event whenever the deployment window opened up. We had all the
ceremony, fear and pressure to make our dates that are talked about as delivery
anti-patterns within the [Continuous Delivery][cd] book.

> ... quick hacks to get newly deployed production systems running
> weren't being driven by such immediate commericial imperatives, but rather by
> the more subtle pressure to release on the day that was planned. The problem
> here is that releases into production are big events. As long as this is true
> they will be surrounded with a lot of ceremony and nervousness.
>
> <cite>Page 20 of [Continuous Delivery][cd]
> by [Jez Humble][jez] and [Dave Farley][dave]
> </cite>

Our software was doing what it needed to do functionally but had defects. These
defects affected our clients a great deal and discouraged them from taking new
releases. This gave us a catch-22 where we could not fix the problems by
shipping new updates in a timely manner and the problems lived much longer than
they needed to in the wild. This led to some undesirable forks in the code
where new functionality needed to be introduced on old releases instead of
shipping an updated version with the new changes.

Most of our problems centered on environment instability. Our favourites
were running out of disk space or IP addresses that would prevent the running
system from continuing to function. We had one big pool for every environment
and so any environment that misbehaved would hurt its neighbours.

We had competing goals compared to some of our clients. They needed stability
whereas we needed to introduce and validate new functionality. Our ability to
produce new software at a certain level of testing vastly out stripped the rate
that it was being consumed downstream. We had been behaving like we could
deploy changes the second they were done but this was not reality everywhere.
We were a rocket strapped to a steam engine.

We wanted to do better. We wanted to break this deployment deadlock and
accelerate the rate at which we could release with confidence.

The Agreement
=======================================

For months we had been operating a fairly sophisticated [Deployment Pipeline][pipeline]
that would validate each commit. This helped us feel confident that we could
ship more frequently with out sacrificing quality.

In order to speed up we realized that we first needed to slow down. Going as
fast as we could was no good if clients did not receive our updates. Slowing
down would also mean investing more into our testing and validation for each
change we made and overall stability. We then came to the following agreement
with our clients for how to proceed.

1. Regular Weekly Deployments
1. Documented Changes
1. More Testing

In the next installment we will explain how the story unfolds and what changed
so that we get better.

[jez]:      https://twitter.com/jezhumble
[dave]:     https://twitter.com/davefarley77
[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[pipeline]: http://martinfowler.com/bliki/DeploymentPipeline.html