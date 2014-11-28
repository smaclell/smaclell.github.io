---
layout: post
title:  "How to Start a New Project"
date:   2014-09-22 23:11:07
tags: deployment
---

If you had to pick one thing to include in your new project what would it be?
Would it be that killer feature your clients are crazy about? Something that
separates you from the competition?

That sounds great. I would love to be able to use it, but you need to deploy it
first! Before any user can see your wondrous creation you need to be able
to deploy your software to a prod-like environment. It doesn't have to be
pretty; it just has to work.

All too often being able to deploy software is thought of as an afterthought.
Building that cool idea takes the forethought, but don't you want to share it?
We have worked with a few teams lately who have gotten fairly far down the
development path before trying to settle on how they would deploy their new
product. Up until now they had been testing on developer boxes and did not see
any problems with this.

The inverse would be building just enough to ship that one killer feature.
Depending on your product that minimum point might be a little further, but
typically it is earlier than you would think. By focusing on this minimum you
can start to iterate and improve what you have by adding to the initial
release. Adding a new feature here, smoothing out the operations experience there, expanding
the initial focus further or any number of paths that make sense.

This is where the concept of an Minimum Viable Product kicks in. To remain
viable keeping your project easily releasable goes a long way. This can mean
simple things like knowing your last stable build or testing the deployment
after every commit. Focusing on the minimum helps streamline your effort and
provide that crucial foundation for future work.

The pressure of remaining releasable and focusing on the why will help keep
your Minimum Viable Product on track as shown by Bill Gross via Andrew Wilkinson.

<div class="center-image">
<blockquote class="twitter-tweet" lang="en"><p>Two different approaches for an MVP (Minimum Viable Product) via Andrew Wilkinson <a href="http://t.co/O1ZYYHT7z4">pic.twitter.com/O1ZYYHT7z4</a></p>&mdash; Bill Gross (@Bill_Gross) <a href="https://twitter.com/Bill_Gross/status/533828430606139392">November 16, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>

There are lots of fantastic ideas packed on how to approach your Minimum
Viable Product and shape your business one release at a time in the book
[Lean Startup][startup]. Shipping multiple small releases helps you learn faster
what works or does not work about your product.

Getting that first release out early avoids many distractions along
the way. You can plan for eventualities, but spending time building an
incredibly complicated system that only attract one user (hi mom!) is overkill.
This is why a simpler deployment initially is recommended. By all means
incorporate it into your continuous integration/deployment system, but focus on
what you need now and maybe not really complex things like multi region
deployments with automatic fail-over. Find your minimum and
iterate slowly to gradually become more comprehensive and robust.

There are many great ways to start deploying today like [Heroku][heroku],
[Google App Engine][google], [Terraform][terraform] and countless others.
I am sure many places have their own way to deploy things that is somewhat
standardized. Talk to your favourite person in operations and I am sure they
have some suggestions. No one in operations? No problem! That means the person
you are looking for is you. Either way you should probably be nice to this
person since you will be working with them **all the time** over the course of your
project. When you finally get called at 2 am with a genuine outage it
helps to have friends.

Please, the next time you start a new project, pick that one key feature then
build it along with a simple deployment process and share it with the world.
What are you waiting for? Hop on that skateboard and Ship it!

[startup]:   http://www.amazon.com/Lean-Startup-Eric-Ries/dp/0670921602/ref=tmm_pap_swatch_0?_encoding=UTF8&sr=&qid=
[heroku]:    https://www.heroku.com/
[google]:    https://cloud.google.com/appengine/docs
[terraform]: https://www.terraform.io/
