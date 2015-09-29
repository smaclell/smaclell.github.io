---
layout: post
title:  "How Preflights Changed Our World"
date:   2015-09-22 01:19:07
tags: builds ci daryl
image:
  feature: buck-stops-here.jpg
  credit: Donna Cleveland CC BY 2.0 (cropped and compressed)
  creditlink: https://www.flickr.com/photos/msdonnalee/6331912582/
---

Preflight builds changed our world. They have made master more stable and are an
essential part of every pull request. A preflight build or preflight is a build
which runs a portion of your CI on a branch being developed. We have introduced
them into several projects and I can the results are dramatic. I don't want to
merge my changes without one first passing the preflight build.

It has been a while since we started using preflights on a few of our projects.
Daryl and a few others first introduced it to our bigger projects and lately we
have been trying to apply the same techniques to our smaller projects.

Our preflights are similar to our complete CI process in that they build, test,
package and deploy our projects. Where they differ is how comprehensive they
are while testing. To speed up the process we run only the most critical
portions of the CI process.

How did we get here?
===============================================================================

Last year a small team of solid developers added preflights to a critical
project. They made the entire process incredibly simple which I think is why it
took off the way it did. The process goes like this:

1. Creating a build automatically starts a preflight build
2. As the preflight progresses the pull request is updated
3. When the preflight finishes or fails an email is sent
4. More preflights can be triggered as needed

We had a CI pipeline, but it would often break due to the number of developers
committing to it. It also took a hours to run which mean if it broke it would
be very hard to get back to normal. This would become even worst if new changes
were committed on top of the broken code.

Many developers would instead try to be extremely careful with their changes.
They would do a great deal more testing and investigation up front. This was
hard to do and could not often cover all the possible changes developers
could make. It still left room from human error and other merge problems.

Preflights allowed us to raise the bar for code before it was merged into
master. As soon as preflights were added people started using them. They were
so simple to use and for typical changes would happen automatically. Quickly
master became more stable and people started focusing more on the results the
preflights were showing.

Contributors started to iterate on improving what was covered by the preflight
tests. Flaky tests became more problematic because they would throw off test
results. Over time they were systematically identified and fixed.

Now several months later the improvement to the builds is dramatic. We can
easily iterate on the code and build breaks are much rarer. All developers can
benefit from having their changes validated better before merging.

The Next Project
===============================================================================

Daryl, who had been on the original project wanted to bring Preflights to our
team. We were about to restart a project and planned a to change the
architecture while keeping the overall behaviour intact.
He advocated setting up preflights early in the project and thought they would
help keep our code stable.

At first the differences to how we behaved were not pronounced. Our normal
workflow barely changed.

<figure class="image-center">
	<img
		title="Around and around with no preflights to be found."
		alt="Our workflow before having preflights."
		src="{{ site.url }}/images/posts/Preflights/Before.png" />
	<figcaption>
	Make code, create pull request, merge, run CI, release, repeat.
	</figcaption>
</figure>

Preflights slightly shifted the workflow to become:

<figure class="image-center">
	<img
		title="The same old cycle with preflights keeping master sound."
		alt="Our workflow after having preflights."
		src="{{ site.url }}/images/posts/Preflights/After.png" />
	<figcaption>
	Make code, create pull request, pass the preflight, merge, run CI, release, repeat.
	</figcaption>
</figure>

As we accelerated the preflights kept finding more and more. They would catch
breaking changes we had not intended. Defects which would have derailed the
other development were stopped dead in their tracks. Our master became more
stable.

As I continued to use this system I started to experiment. If I was confident
in my changes sometimes I would kick off a preflight to see whether it was
valid. The tests were more comprehensive than my local build and I could get
better feedback early. This allowed me to work more asynchronously without
babysitting builds. The notifications would let me know whether my changes
were good or bad.

It all clicked for me when I accidentally merged too soon. I had made some
changes and merged prior to the preflight passing. What I did not know at the
time was my changes had introduced defects which broken master. It has been
weeks of using the preflight builds and this was the first time I could remember
having broken our master.

Although we rarely broke master, preflights made it very clear when changes
might cause problems. Instead of relying on humans being careful, we can now
let machines protect us from ourselves.

By the Numbers
===============================================================================

I feel like this post is less cool without qualifying the exact improvements
and numbers. Sadly we have been using preflights long enough and aggressively
purge old build history. I was able to look at the stats on the pull requests
from part of September.

We had 43 pull requests with hundreds of commits which triggered over a
hundred builds. 98% of pull requests with a passing build with my accidental
merge being the one pull request without a passing build. We found 42% of our
pull request failed one or more builds and needed more work. In other words,
18/43 pull requests were prevented from breaking our codebase.

Our failing preflights looks quite high without context. I do feel a little bad
about these numbers, but given the circumstances and type of project may be
reasonable. We essentially rewrote the internals of project while preserving
the overall behaviour. We were very active with hundreds of commits across
several developers.

I view preflights for our project as a success. Each of
those failures could have broken master and delayed the entire team. Instead
failures were stopped before they were merged.

Tradeoffs and Limitations
===============================================================================

This might sounds like rainbows and unicorns. Like everything there are tradeoffs and
limitations. We learnt several lessons from the process and have more areas to
improve.

**Our end to end process is slower**

The preflights essentially double the
amount of time required to go from initial commit to deployed to
production. Overlapping preflights with code reviews helps mitigate this.
It is great for complex reviews which are longer than the preflight, but
for simple changes the extra waiting is annoying.

We have been able to speed up the feedback by running more of the process in
parallel. Running in parallel has increased our complexity and led to other
challenges.

**Limited coverage leaves gaps**

We have extended tests which require more
hardware or special tools. We cannot use these special assets for every
preflight. We also chose to run more important tests in the preflight and
leave more comprehensive validation for the existing CI pipeline. This has
meant there are gaps in our coverage where issues can sneak in.

We have iteratively improved this process by filling in larger gaps we find or
moving tests into the preflight. Running more in parallel has allowed us to
increase the amount we can validate in the same amount of time.

**Harder Recovery**

If an error does sneak through the preflight or is merged
too soon it is harder to get back out. When errors occurred before having
preflights too often developers would try to fix the change. Since the new fix
also goes through the preflight system getting back to green by fixing the
problem is harder.

To counteract this we try to revert the change immediately by passing the
preflights then fix the issue in a separate pull request. Reverting problematic
commits is a common practice for CI and is even more important when using
preflights.

**Dependencies add complexity**

For the both the initial project and our example
additional dependencies make the process more complicated. The ideal would be
if all changes could be validated by the preflight. This harder when
incorporating third party services or managing external configuration.

Our typical approaches have been to reduce the extra dependencies, keep the
contracts relatively stable or version the other components. This is a big area
for improvement and challenge for our projects.

**Stability is paramount**

Intermittent failures make the preflights less
effective. The entire system, services and scripts need to be consistent.
We want the pass/fail from the preflights to be a clear indication of whether
your code should be merged or not. When the preflights randomly fail it is hard
to trust their results.

As we continue to iterate on the process we have tried to stabilize any
problematic components. A common offender was sensitive integration tests
which we have slowly fixed.

As many improvements to the preflight system as possible are made using the
preflight system. This forces us to keep our changes safe and small. Any change
which cannot be validated by the preflights should be the exception and should
be tested thoroughly before being merged.

Summary
===============================================================================

Using preflight builds has dramatically made our projects more stable. We have
noticed big improvements with our first few projects. We have continued to
refine how preflights interact with our processes. They have changed how we work.

I think adding preflights early will be important to our new projects. We know
CI is essential for all our projects. Preflight builds take this to the next
level and find problems before they reach master.

If you have troubles with stability or want a rock solid master branch? Try using preflights.

<hr />

*Thanks to the original team who put together the other preflights. They have
definitely saved my bacon and I appreciate you effort to get it introduced.*

*Thanks Daryl for promoting preflight builds with the team. It has made our
lives better and kept the code stable.*
