---
layout: post
title:  "Extreme Deployment As A Feature"
date:   2014-09-22 23:11:07
tags: deployment, projects
image:
  feature: skys-the-limit-feature.jpg
  credit: Jackie Meredith
  creditlink: skys-the-limit-thumb.jpg
---

In my previous post about [how to start new projects][new-projects] I talked
about building a killer feature and deployment at the same time then releasing.
This idea caused an interesting discussion with my coworkers that included the
extreme position of shipping only the deployment as the first feature.

I don't fully agree with the idea but my one coworker Matt was adamant about
it. Matt is a pretty smart guy so I decided to think about it some more. This
is what I was able to come up with and I think there is a range of situations
that doing the deployment before the main project could be worth while.

Why go to the extreme?
===============================================================================

The deployment first or empty release was was particularly attractive for my
coworker Matt. Taking this approach has the following benefits:

**All features include deployment considerations from day zero.** This idea is
from Mike Mooney who advocates for doing your deployment early. According to
Mike an early deployment forces developers to ask
["How will this affect the deployment process?"][cd-intro]. It becomes part of
adding any feature. This would be even more so if the first thing the team does
is implement a basic deployment process.

**Better separation between the deployment and initial product features.** In a
new project the team is probably still coming up to speed on what problems are
being solved, how best to approach them and what unknowns might be lurking in
the shadows. Removing concerns over how the project will be deployed lets the
team focus on the core project. For me this is a little counter intuitive since
the deployment is a critical part of being able to release new features. If you
consider that most features do not impact the deployment or can be adjusted to
minimize the changes it can provide a foundation for growing the project.

**Practices deploying/releasing immediately.** Teams that ship infrequently or
are less comfortable with deployments/releases can benefit by taking time out
just for this activity. The start of a project is the least risky time to do
invest in the deployment since any deadlines are the furthest away. If they
have never tried anything like this before or have not worked with the other
teams that control production this can be a great introduction before delving
deeper into the actual project. This is particularly important in an enterprise
environment which can have many additional touch points or stakeholders that
are included in deployments. Startups probably care less about this since
every minute spent is one step closer to extinction or outlandish riches.

Why you might want to not go all the way
===============================================================================

I was not convinced that this strategy is necessary or that it has significant
advantages to including the deployment with your first feature. Having very
little of the application included at the start feel like throwing the baby out
with the bath water. The whole reason you are trying to deploy your code is to
ship your application!

The closest comparison I can think of is "doing" TDD. For most people do
something similar to TDD but not the real thing. One common variant is to
over think it and start writing a great deal of code in anticipation for what
is needed. Your solution matches you what you think you need but not necessary
the best model that would evolve from iteratively implementing the solution
one test at a time then refactoring. For fun examples of this check out
[TDD as if you meant it][tdd].

The same would be true if you built a deployment process without the
application to go with it. You want your deployment to grow and change with
your application. Getting too far ahead of yourself can cause things to become
unbalanced or over engineered. I would much rather have a more basic deployment
and some minimal features than an amazing deployment with nothing in it.

However, the more we discussed it the more the other side seemed attractive for
environments where deploying is hard or normally an after thought. If you think
that your could benefit from being more deployment conscious, concentrating on
your project over your deployment or practicing deploying more then consider
starting with only your deployment.

[new-projects]: /posts/how-to-start-a-new-project/
[cd-intro]:     https://www.airpair.com/continuous-deployment/posts/continuous-deployment-for-practical-people#6-1-automate-deployments-from-step-zero
[tdd]:          http://cumulative-hypotheses.org/2011/08/30/tdd-as-if-you-meant-it/
