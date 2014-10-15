---
layout: post
title:  "Deploys Becoming Boring"
date:   2014-09-22 23:11:07
tags: deployment process
---

It wasn't always easy for us to promote our system. It took time and effort to
get there and a whole lot of iterating. This is our story about how over the
course of a few weeks we were able to go from a system with little confidence
to smooth regular updates that are downright boring.

In The Beginning
=======================================

We started out our project with large releases. This was not how we wanted it
to be but this is how things ended up. Promoting each release turned into a
serious event whenever the deployment window opened up. We had all the
ceremony, fear and pressure to make our dates that are talked about as
continuous delivery anti-patterns within the [continuous delivery][cd] book.

TODO: Block quote CD

Our software was doing what it needed to do functionally but had defects. These
defects affected our clients a great deal and discouraged them from taking new
releases. This gave us a catch-22 where we could not fix the problems by
shipping new updates in a timely manner and the problems lived much longer than
they needed to in the wild. This led to some undesirable forks in the code
where new functionality needed to be introduced on old releases instead of
shipping an updated version with the new changes.

Most of our defects centerred around environment instability. Our favourites
were running out of disk space or IP addresses that would prevent the running
system from continuing to function. We had one big pool for every environment
and so any one environment that misbehaved could hurt its nieghbours.

We had competeting goals compared to some of our clients. They needed stability
whereas we needed to introduce and validate new functionality. Our ability to
produce new software at a certain level of testing vastly out stripped the rate
that it was being consumed downstream. We had been behaving like we could
deploy changes the second they were done but this was not reality everywhere.
We were a rocket strapped to a steam engine.

We wanted to do better. We wanted to break this deployment deadlock and
accelerate the rate at which we could release with confidence.

The Agreement
=======================================

<span id="agreement"></span>

For months we had been operating a fairly sophisticated [Deployment Pipeline][pipeline]
that would validate each commit. This helped us feel confident that would could
ship more frequently.

In order to speed up we realized that we first needed to slow down. Going as
fast as we could was no good if clients did not receive our updates. Slowing
down would also mean investing more into our testing and validation early. We
then came to the following agreement with our clients for how to proceed.

# Regular Weekly Deployments
# Documented Changes
# More Testing

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

As part of __[The Agreement](#agreement)__ we had instituted more comprehensive
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

Notes
=======================================

Draw the deployment pipeline
Don't describe feelings, describe actions.

Notes to self:

* Do no patronize
* There is only us
* Be humble
* No complaints
* Believe in the best intent
* Avoid editorializing the reactions of others
* Switch to lack of confidence instead of lack of trust

Routine Again
=======================================

Each success built more trust.
Any member of the team can perform the deployment and is downright boring.
Stakeholders who wanted to slow previously now want fixes and features early.

Next
=======================================

Even faster, full continous deployment. Twice as fast to other environments.

Can I include a diagram of our pipeline?

[cd]:       http://www.amazon.com/dp/B003YMNVC0/
[pipeline]: http://martinfowler.com/bliki/DeploymentPipeline.html
[bag]:      http://www.catb.org/jargon/html/B/brown-paper-bag-bug.html