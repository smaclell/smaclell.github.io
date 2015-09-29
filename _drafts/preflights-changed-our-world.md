---
layout: post
title:  "How Preflights Changed Our World"
date:   2015-09-22 01:19:07
tags: preflights builds ci daryl quality
image:
  feature: buck-stops-here.jpg
  credit: Donna Cleveland CC BY 2.0 (cropped and compressed)
  creditlink: https://www.flickr.com/photos/msdonnalee/6331912582/
---

Preflight builds changed our world. They have made master more stable and are an
essential part of every pull request. A preflight build or preflight is a build
which runs a portion of your CI on a branch being developed. We have introduced
preflights into several projects and I can say the results are dramatic. I don't want to
merge my changes without first passing the preflight build.

It has been a while since we started using preflights.
Daryl and a few others first introduced then to our bigger projects. Lately we
have been trying to apply the same techniques to smaller projects.

Our preflights are similar to our complete CI process in that they build, test,
package and deploy the project. Where they differ is how comprehensive they
are while testing and the deployment complexity. To speed up the process we run
only the most critical portions of the CI process and simplify the deployment.
We want the developers to get faster feedback while still providing more
thorough validation.

How did we get here?
===============================================================================

Last year a small team of solid developers added preflights to a critical
project. They made the entire process incredibly simple which I think is why it
took off the way it did. The process goes like this:

1. Creating a pull request automatically starts a preflight build
2. As the preflight progresses the pull request is updated
3. When the preflight finishes or fails an email is sent
4. More preflights can be triggered as needed

We had a CI pipeline, but it would often break due to the number of developers
committing to it. It also took hours to run which meant if it broke it would
take a long time to get back to normal. This would become even worst if new
changes were committed on top of the broken code.

Many developers would instead try to be extremely careful with their changes.
They would do a great deal of extra testing and investigation up front. This was
time consuming and could not cover all possible changes the developers
could make. It still left room from human error and other merge problems.

Preflights allowed us to raise the bar for code before it was merged into
master. As soon as the preflights were added people started using them. They were
so simple to use and for typical changes would happen automatically. Quickly
master became more stable and people started focusing more on the results the
preflights were showing.

The started a virtuous cycle, giving the preflights more attention which led to further improvements.
Contributors started to iterate on improving what was covered by the preflight
tests. Flaky tests became more problematic because they would throw off test
results. Over time bad tests were systematically identified and fixed.

Now almost a year later I don't think I could work on the project without using the
preflights. The added confidence and stability from the preflights is dramatic. We can
easily iterate on the code and build breaks are much rarer. All developers can
benefit from having their changes validated better before merging.

The Next Project
===============================================================================

Daryl, who had been on the original team implementing preflights wanted to bring them to our
team. We were about to restart a project and planned to change the
architecture while keeping the overall behaviour intact.
He advocated setting up preflights early in the project and thought they would
help keep our code stable. We agreed and I soon set them up.

Our normal workflow was:

<figure class="image-center">
	<img
		title="Around and around with no preflights to be found."
		alt="Our workflow before having preflights."
		src="{{ site.url }}/images/posts/Preflights/Before.png" />
	<figcaption>
	Make code, create pull request, merge, run CI, release, repeat.
	</figcaption>
</figure>

At first the difference in our behaviour was not pronounced.
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

As development accelerated, the preflights caught breaking changes we had not intended.
Defects which would have derailed development were stopped dead in their tracks.
Our master became more stable despite our active development.

As I continued to use the preflights I started to experiment. If I was confident
in my changes sometimes I would kick off a preflight early to see whether what
I had done was valid. The tests were more comprehensive than my local build
and I could get better feedback early. This allowed me to work more
asynchronously less babysitting builds. The notifications would let me know
whether my changes were good or bad.

It all clicked for me when I accidentally merged too soon. I had made some
hasty changes and merged prior to the preflight passing. My changes broke
master in a way which would have been caught by the preflights. It has been
weeks of using the preflight builds and this was the first time I could remember
having broken our master.

Thanks to the preflights we rarely broke our master. The preflights made it
very clear when changes would cause problems. Instead of relying on humans
being careful, we could now let machines protect us from ourselves.

By the Numbers
===============================================================================

I feel like this post is less cool without qualifying the exact improvements
and how many breakages we prevented. Sadly we have been using preflights long enough and aggressively
purge old build history. While I was not able to get a comparison from before
the preflights, I was able to look at the statistics on our pull requests
for part of September.

We had 43 pull requests including hundreds of commits which triggered over a
hundred builds. 98% of pull requests had a passing build with my accidental
merge being the one pull request without a passing build. We found 42% of our
pull request failed one or more builds and needed more work. In other words,
18/43 pull requests were prevented from breaking our codebase.

Our failing preflights looks quite high without context. I do feel a little bad
about these numbers, but given the circumstances and project they may be
reasonable. We essentially rewrote the internals of a project while preserving
the overall behaviour. We were very active with hundreds of commits across
several developers.

I view the preflights for our project as a success. Each of
those failures could have broken master and delayed the entire team. Instead
failures were stopped before they were merged.

Tradeoffs and Limitations
===============================================================================

This might sounds like rainbows and unicorns. Like everything there are tradeoffs and
limitations. We learnt several lessons from the process and have more areas to
improve.

**Our end to end process is slower**

The preflights nearly double the
amount of time required to go from initial commit to deployed to
production. Overlapping preflights with code reviews helps mitigate this.
It is great for complex reviews which are longer than the preflight, but
for simple changes the extra waiting is annoying.

We have been able to speed up the preflight feedback by running more of the process in
parallel. Running in parallel has increased our complexity and led to other
challenges.

**Limited coverage leaves gaps**

We have extended tests which require more
hardware or special tools. We cannot use these special assets for every
preflight. We also chose to run more important tests in the preflight and
leave more comprehensive validation for the existing CI pipeline. This has
meant there are gaps in our coverage where issues can sneak in.

We have iteratively improved this process by filling in the larger gaps we find and
moving tests into the preflight from the CI. Running more of the build in parallel has allowed us to
increase the amount we can validate in a given amount of time.

**Harder Recovery**

If an error does sneak through the preflight or is merged
too soon it is harder to get back to normal. When errors occurred before having
preflights developers would often try to fix the change by pushing more changes.
With preflights the new fix must also pass a preflight which makes fixing the
problem and getting back to green harder.

To counteract this we try to revert the change immediately and bypassing the
preflights. In this case we know the code worked before and should continue
working without the added changes. We then fix the issue in a separate pull
request. Reverting problematic commits is a common practice for CI and is
even more important to do when using preflights.

**Dependencies add complexity**

For the both the initial project and our new project
additional dependencies make the preflights more complicated. The ideal would be
if all changes could be validated by the preflight. This harder when
incorporating third party services or managing external configuration.
Coordinating updates and performing them safely is important to not break
the preflights. We have had a few breaks caused by updating the configuration
too soon or the project being tested changing data badly which broke existing
deployments.

Our typical approaches have been to reduce the extra dependencies, keep the
contracts relatively stable or version the other components. This is a big area
for improvement and challenge for our projects.

**Stability is paramount**

Intermittent failures make the preflights less
effective. The entire system, services and scripts need to be consistent.
We want the pass/fail from the preflights to be a clear indication of whether
your code should be merged or not. When the preflights randomly fail it is easy
to lose trust in their results.

As we continue to iterate on the process we have tried to stabilize any
problematic components. A common offender was sensitive integration tests
which we have slowly fixed. We have added extra redundancy and monitoring to
vital services.

We want to make improvements to preflights safely. This means making small
changes which are also validated by the preflights. Any change
which cannot be validated by the preflights should be the exception and should
be tested thoroughly before being merged.

Summary
===============================================================================

Using preflight builds has dramatically made our projects more stable. We have
noticed big improvements with our first few projects. We have continued to
refine how preflights interact with our processes. They have changed how we work.

I think adding preflights early will be important for new projects. We know
CI is essential for all our projects. Preflight builds take this to the next
level and find problems before they reach master.

If you are have troubles with stability or want a rock solid master branch then try using preflights.

<hr />

*Thanks to the original team who put together the first set of preflights. They have
definitely saved my bacon and I appreciate your effort to get them introduced.*

*Thanks Daryl for promoting preflight builds within the team. It has made our
lives better and kept the code stable.*
