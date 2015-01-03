---
layout: post
title:  "Deployment First To The Extreme"
date:   2014-09-22 23:11:07
tags: deployment, projects
image:
  feature: skys-the-limit-feature.jpg
  credit: "Jackie Meredith"
  creditlink: https://flic.kr/p/jk1B8J
---

In my previous post about [how to start new projects][new-projects] I talked
about building a killer feature and deployment at the same time before releasing.
This follow up post was inspired by an interesting discussion with my co-workers
while writing the original post. The conversation shifted to what would happen
if you took deploying early to the limit. What if you released only the
deployment first with nothing in the product?

What do you mean released it with nothing? I mean build your product, package
the binaries and then deploy them into a testing environment and ideally
production. Go as far as you can. Do not include any features you intend for
the final application. Only do a basic deployment and maybe some hooks for
monitoring. Then ship it.

The Reasons
===============================================================================

I didn't fully agree with the idea at first but my colleague, Matt, was adamant about
it. Matt is a pretty smart guy so I decided to think about it some more. These
are the benefits I was able to come up with and I think there is a range of situations
where doing the deployment before the main project could be worthwhile.

**All features include deployment considerations from day zero.** This idea is
from Mike Mooney who advocates for doing your deployment early. According to
Mike, an early deployment forces developers to ask
["How will this affect the deployment process?"][cd-intro]. It becomes part of
adding any feature. If the first thing the team does is implement a basic
deployment process they will be more mindful of changes that affect it.

**Separation between the deployment and initial product features.** In a
new project the team is probably still coming up to speed on what problems are
being solved, how best to approach them and what unknowns may be lurking in
the shadows. Removing concerns over how the project will be deployed lets the
team focus on the core project. If you consider that most features do not
impact the deployment or can be adjusted to minimize the changes required, an
existing deployment process can provide a solid foundation for growing the
project.

**Practices deploying/releasing immediately.** Teams that ship infrequently or
are less comfortable with deployments/releases can benefit by taking time out
for this activity. The start of a project is the least risky time to
invest in the deployment and practice these activities. If the delivery team
has never tried to deploy their own products or have not worked with the other
teams that control production this can be a great introduction before delving
deeper into the actual project. Practicing the deployment in complete isolation
prior to having a project to maintain on top of it provides a safe way for the
team to get experience with their deployment process.

**Getting connected**. Another big theme of the conversation was understanding
the social dynamics around processes within a company. This relates to larger
companies where there likely are established norms for how to deploy software
and perform projects. Establishing relationships with the other teams connected
to the process will help streamline future releases and avoid common errors
they already know about. It might be easy to find out who you need to work with
to get things done but it can be a completely different experience than
actually going through with it. This is not applicable for startups who have
more autonomy over their projects.

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
one area while focusing on what provides the most value. Early in a project
being able to deploy anything is extremely valuable to get early feedback. The
more functional and complete this process becomes the more diminishing the
returns for spending more time working on it.

When it comes to implementing your deployment before any functionality it is
imperative to balance how much effort and time is dedicated to creating the
deployment process before focusing on the application. Ideally it is a
relatively painless process that can be finished within a few days or sprint.
Working solely on the deployment for months is a warning sign that you are
doing too much or waited too long to address the problem.

Dedicating too much time to the deployment process without the application can
result in over-engineering and be more effort to maintain in the long run.
Ideally it is a very simple process at first because initially your application
will be simple. Start by finding the minimal requirements for the deployment
then automating only that. Think of the simplest thing you could possibly to
then try it. It is easy to get carried away envisioning scenarios that require
more automation only to find that it isn't actually needed. By doing the
absolute minimum deployment then focusing solely on your application
lets you avoid over complicating your deployment and your application.

Software is a means to an end. Your deployment too is a vehicle to ship your
software. Using this approach requires that you finish your deployment then
get back to the project at hand quickly.


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

[new-projects]: {{site.url}}/posts/how-to-start-a-new-project
[cd-intro]:     https://www.airpair.com/continuous-deployment/posts/continuous-deployment-for-practical-people#6-1-automate-deployments-from-step-zero
