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

Iterating
=======================================

This was not smooth at first but soon became much better. We still had alot of
bad habits from our early deployments which resulted in some bad behaviour. In
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

As part of __[The Agreement](TODO#the-agreement)__ we had instituted more comprehensive
smoke testing. This meant that the entire system would run through in the new
environment to verify that the most critical operations worked. This was done
with our clients to share the new releases with them and collaborate more.

In our dev environment we also bolstered our testing with more scenarios that
covered the use cases that had hindered our clients before. This started off as
manual acceptance testing that was time consuming and onerous. Week by week we
automated this process so that it was no longer a final stamp on each release
but was triggered by every commit as part of the deployment pipeline for each
component. This acted like a funel for issues making sure that each part was
stable independantly then testing everything together to confirm the resulting
integration was solid. Once fully automated we could be very confident in each
change that was being made to the system.

TODO Funel image

Each new issue that came up was dealt with immediately and then more permanent
fixes were put into place to prevent them from occuring again. This meant more
monitoring and diagnostics which enabled us to deal with issues before they
hindered the services we had created. We invested further into hardenning
our environments and isolating the pools of resources used by each one. This
prevented the cross contamination we were seeing and vastly improved stability.

Another interesting side effect occurred as we continued this process. Early on
the changes were quite large but eventually shrunk much smaller. The acclerated
releases meant that we could no longer do large sweeping changes to the system
and instead needed to think about how they could be introduced incrementally.
By having small changes it was easier to get the quick feedback we wanted while
keeping the entire system stable. This continue to improve the quality of our
releases.

We were now able to consistently add new functionality and improve the capabilities of the system safely.

We started building things smaller and our quality went up.

[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[pipeline]: http://martinfowler.com/bliki/DeploymentPipeline.html
[bag]:      http://www.catb.org/jargon/html/B/brown-paper-bag-bug.html