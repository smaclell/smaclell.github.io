---
layout: post
title:  "Extreme Deployment As A Feature"
date:   2014-09-22 23:11:07
tags: deployment, projects
---

In my previous post about [how to start new projects][new-projects] I talked
about building a killer feature and deployment at the same time then releasing.
This idea caused an interesting discussion with my coworkers that included the
extreme position of shipping only the deployment as the first feature.

The deployment first or empty release was was particularly attractive for my
coworker Matt. Taking this approach has the following benefits:

**All features include deployment considerations from day zero.** If before the
first line of code is written a deployment exists and is regularly tested it
will be much harder to unintentionally break it. In fact, any new feature that
is added will consider their impact on the deployment from then on.

**Better separation between the deployment and initial product features.** In a
new project the team is probably still coming up to speed on what problems are
being solved, how best to approach them and what unknowns might be lurking in
the shadows. Removing concerns over how the project will be deployed lets the
team focus on the core project at hand. For me this is a little counter
intuitive since the deployment is a critical part of being able to release new
features but since most extra features do not often impact the deployment
process it can ideally be something that the team can take for granted as ready
for use.

**Practices deploying/releasing immediately.** Teams that ship infrequently or
are less comfortable with deployments/releases can benefit by taking out time
just for this activity. It stands to reason that the start of a project is the
least risky time to do it since any deadlines are the furthest away. If they
have never tried anything like this before or have not worked with the other
teams that control production this can be a great introduction before delving
into the meat of the project. This is particularly important in an enterprise
environment which can have many additional touch points or stakeholders that
are included in this process. Startups probably care less about this since
every minute is one step closer to extinction or outlandish riches.

An empty deployment feels wrong to me since the skeleton you ship may be very
different than the actual system. Building and releasing actual functionality
helps prove you have done just enough work on the deployment. The opposite does
not necessarily hold true and is harder to know when to stop.

You still might want to consider this extreme. It can provide practice for the
team at deploying what will become your product. It ensures that a deployment
is in place before anything else happens. Ideally the deployment would be used
within a continuous integration process and would continue to function as the
project grows and changes.

TODO: FIX
[new-projects]: /posts/how-to-start-a-new-project
[cd-intro]:  https://www.airpair.com/continuous-deployment/posts/continuous-deployment-for-practical-people#6-1-automate-deployments-from-step-zero

