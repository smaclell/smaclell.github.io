---
layout: post
title:  "How to Start a New Project"
date:   2014-09-22 23:11:07
tags: deployment, projects
---

**Takeaway:** Start new projects with one key feature and a simple deployment.
Iterate from there.

If you had to pick one thing to include in your new project what would it be?
Would it be that killer feature your clients are crazy about? Something that
separates you from the competition?

That sounds great. I would love to be able to use it, but you need to deploy it
first! Before any user can see your wondrous creation you need to be able
to deploy your software to a prod-like environment. It doesn't have to be
pretty; it just has to work.

All too often being able to deploy software is an afterthought. Building that
cool idea takes the forethought, but shipping it doesn't. It can be easy to
work for months without shipping. This delays critical feedback about whether
the application will work as a complete package with the current design.
Perhaps it does not scale adequately or is not quite right end to end but you
would never know unless you tried it in the wild<a href="#note-1">*</a>.

Bolting on a deployment later in the process becomes progressively harder the
larger and more complicated the application becomes. On a developer machine
everything seems to work perfectly thanks to subtle dependencies and custom
configuration. Assumptions can sneak in that are not viable in production like
cloning repositories directly from repos on [github][github].

This is why starting with a simple deployment is recommended. Try this approach:

<span id="step-1"></span>

1. Implement killer feature
1. Automate enough to use killer feature
1. Ship it
1. GOTO **<a href="step-1">Step 1</a>**

Is the server up? Can it receive traffic? Do the pages for the feature work?
That is probably enough of a deployment. Once you have hit this basic milestone
continue by shipping the application. By minimizing time spent on the
deployment process you can maximize working on what matters to the business and
users. Subsequent releases can build on the deployment from the earlier
releases and may not need many changes if the new functionality does not impact
the deployment.

If shipping your feature hurts or the code is difficult to operate then spend
time making it better and repeat. Invest a little each iteration to making it
better like adding deployment testing to your continuous integration process or
simplifying how you manage release assets/binaries. After a few iterations, you
will get into a groove and changing either the software or deployment will be
easier.

There are many great ways to start deploying today like [Heroku][heroku],
[Google App Engine][google], [Terraform][terraform], [Docker][docker] and countless others.
I am sure many places have their own way to deploy things that is somewhat
standardized. Talk to your favourite person in operations and I am sure they
have some suggestions. No one in operations? No problem! That means the person
you are looking for is yourself. Either way you should probably be nice to this
person since you will be working with them **all the time** over the course of
your project. When you finally get called at 2 am with a genuine outage it
helps to have friends.

Please, the next time you start a new project, pick that one key feature then
build it along with a simple deployment process and share it with the world.
What are you waiting for? Go deploy your first feature!

<hr />

*I would like to thank Joshua Groen and Matt Campbell for helping review this
post. Stay tuned to more about deploying first thanks to the lively discussion
we had about it.*

<hr />

<span id="note-1"></span>
1. Yes, you could get feedback on just your UI and whether the data looks okay.
   That is a nice start but is only one aspect of your system. Go all the way.
   Deploy it. Seriously. If you got this far and tasted a bit of the Kool-Aid,
   what are you waiting for?

[github]:    https://github.com/
[heroku]:    https://www.heroku.com/
[google]:    https://cloud.google.com/appengine/docs
[terraform]: https://www.terraform.io/
[docker]:    https://www.docker.com/
