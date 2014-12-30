---
layout: post
title:  "Deployment First To The Extreme"
date:   2014-09-22 23:11:07
tags: deployment, projects
image:
  feature: skys-the-limit-feature.jpg
  credit: "Jackie Meredith"
  creditlink: skys-the-limit-thumb.jpg
---

In my previous post about [how to start new projects][new-projects] I talked
about building a killer feature and deployment at the same time before releasing.
This idea started an interesting discussion with my coworkers that included the
extreme of shipping only the deployment first with nothing in the product.

Why?
===============================================================================

I didn't fully agree with the idea at first but my colleague, Matt, was adamant about
it. Matt is a pretty smart guy so I decided to think about it some more. This
is what I was able to come up with and I think there is a range of situations
where doing the deployment before the main project could be worthwhile.

**All features include deployment considerations from day zero.** This idea is
from Mike Mooney who advocates for doing your deployment early. According to
Mike, an early deployment forces developers to ask
["How will this affect the deployment process?"][cd-intro]. It becomes part of
adding any feature. If the first thing the team does is implement a basic
deployment process they will be more mindful of changes that affect it.

**Better separation between the deployment and initial product features.** In a
new project the team is probably still coming up to speed on what problems are
being solved, how best to approach them and what unknowns may be lurking in
the shadows. Removing concerns over how the project will be deployed lets the
team focus on the core project. For me this is a little counter intuitive since
the deployment is a critical part of being able to release new features. If you
consider that most features do not impact the deployment or can be adjusted to
minimize the changes it can provide a solid foundation for growing the project.

**Practices deploying/releasing immediately.** Teams that ship infrequently or
are less comfortable with deployments/releases can benefit by taking time out
for this activity. The start of a project is the least risky time to
invest in the deployment and practice these activities. If the delivery team
has never tried to deploy their own products or have not worked with the other
teams that control production this can be a great introduction before delving
deeper into the actual project. In an enterprise environment getting to know
the touch points or stakeholders that are included in deployments is extremely
beneficial. Startups probably care less about this since
every minute spent is one step closer to extinction or outlandish riches.

Moderation
===============================================================================

I was not convinced that this strategy was had significant
advantages over implementing a simple deployment with your first feature. Having very
little of the application included at the start feels like throwing the baby out
with the bath water. The whole reason you are trying to deploy your code is to
ship your application!

Both implementing the deployment first and implementing the deployment with the
early functionality promote a greater focus on deployablity. As with most
architecture, the deployment grows best incrementally with the application it
is designed for. For many projects this means moderating the investment in any
one area to preserve focus on what provides the most value. Early in a project
being able to deploy anything is extremely valuable to get early feedback. The
more functional and complete this process becomes the more diminishing the
returns for spending more time working on it.

When it comes to implementing your deployment before any functionality it is
imperative to balance how much effort and time is dedicated to creating the
deployment process before focusing on the application. Ideally it is a
relatively painless process that can be finished within a few days or sprint.
Working solely on the deployment for months is a warning sign that you are
doing too much or waited too long to address the problem.

The Final Word
===============================================================================

However, the more we discussed it the more the other side seemed attractive for
environments where deploying is hard or normally an afterthought. If you think
that your project could benefit from being more deployment conscious, concentrating on
your deployment over your project temporarily or practicing deploying more, then
consider starting with only your deployment before anything else.

<hr />

*I would like to thank Joshua Groen and Matt Campbell for helping review this
post and eventually winning me over.*

[new-projects]: /posts/how-to-start-a-new-project/
[cd-intro]:     https://www.airpair.com/continuous-deployment/posts/continuous-deployment-for-practical-people#6-1-automate-deployments-from-step-zero
