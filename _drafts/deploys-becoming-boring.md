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

The Iterations
=======================================

This was not smooth at first but soon became much better.

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

The Agreement
=======================================

* regular weekly deployments
* known changes
* validated

The Iterations
=======================================

At first not smooth but became stable within a few iterations.
Found a few defects with the process that were fixed right away.
Initially there was alot of pressure to CRAM more in but now happily wait
until the next week.
Now it is down to one click per service.
We started building things smaller and our quality went up.
Included more validation in the process.

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