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

Preflights changed our world. They have made master more stable and are an
essential part of every pull request. A preflight build or preflight is a build
which runs a portion of your CI on a branch being developed. We have introduced
them into several projects and I can the results are dramatic. I don't want to
merge my changes without one first passing the preflights.

It has been a while since we started using preflights on a few of our projects.
Daryl and a few others first introduced it to our bigger projects and lately we
have been trying to apply the same techniques to our smaller projects.

Our preflights are similar to our complete CI process in that they build, test,
package and deploy our projects. Where they differ is how comprehensive they
are while testing. To speed up the process we may run the most critical
portions of the CI process.

How did we get here?
===============================================================================

Last year a small team of solid developers added preflights to a critical
project. They made the entire process incredibly simple which I think is why it
took off the way it did. The process goes like this:

1. When you created a new pull request a build would automatically start.
2. The pull request would be updated as the build/tests progressed.
3. The build finishing or failing would update the pull request and email the creator
4. Additional builds can be triggered as needed or if more changes are added

We had a CI pipeline, but it would often break due to the number of developers
committing to it. It also took a hours to run which mean if it broke it would
be very hard to get back to normal. This would become even worst if new changes
were committed on top of the broken code.

Many developers would instead try to be extremely careful with their changes.
They would do a great deal more testing and investigation up front. This was
hard to do and could not often cover all the possible changes developers
could make.

Preflights allowed us to raise the bar for code before it was merged into
master. As soon as preflights were added people started using them. They were
so simple to use and for typical changes would happen automatically. Quickly
master became more stable and people started focusing more on the results the
preflights were showing.

Contributors started to iterate on improving what was covered by the preflight
tests. Flaky tests became more problematic because they would throw off test
results. Over time they were systematically identified and fixed.

Now several months later the improvement to the builds is dramatic. We can
easily iterate on the code and build breaks are much rarer. The large number
of developers have their changes better validated before merging.

The Next Project
===============================================================================

Daryl, who had been on the original project wanted to bring Preflights for our
team. We were about to restart a project and expected many changes to happen.
He advocated setting up preflights early in the project and thought they would
help keep our code more stable.

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

With preflights the work flow only slightly changed to become:

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
baby sitting builds. The notifications would let me know whether my changes
were good or bad.

It all clicked for me when I accidentally merged too soon. I had made some
changes and merged prior to the preflight passing. What I did not know at the
time was my changes had introduced defects which broken master. It has been
weeks of using the preflights and this was the first time I could remember
having broken our master.

Why not Gated Builds?
===============================================================================

We had several discussions about whether or not prevent commits to master which
had not passed a preflight build. While this would ensure a higher level of
quality this turns out to be unnecessary. You could commit without waiting for
preflights to pass. The key idea that is that you are responsible for your
actions. If what you commits breaks the build and you did not wait for the
preflights then you have done something bad.

We do want to merge some changes faster. There are some changes, like updating
documentation, which do not need the additional testing/validation from the
preflights. Another issue which can arise are issues with the pipeline which
can only be fixed by merging other cases. I do not believe this has happened,
but allowing developers to use their best judgement has been working.

Tradeoffs and Limitations
===============================================================================

This sounds like rainbows and unicorns. Like everything there are tradeoffs and
limitations.

*Our end to end process is slower.* The preflights essentially double the
amount of time required for a change to go from initial commit to deployed to
production. We have mitigated this by overlapping the preflights with reviews.
This is great because our average reviews are longer than the preflight, but
for simple changes this can be annoying. We have been able to reduce this
impact by running more of the process in parallel, but this increases our
complexity and leads to other challenges.

*Limited coverage leaves gaps.*  We have extended tests which require more
hardware or special tools. Right now we could not used them for every
preflight. We also chose to run more important tests in the preflight and
leave more comprehensive validation for the normal CI pipeline. This has
meant there are gaps in our coverage where issues can sneak in. We have
iteratively improved this process by filling in larger gaps we find. Another
core improvement has been to use more tests running in parallel to increase
the amount we can validate in the same amount of time.

*Dependencies add complexity*. For the both the initial project and our example
additional dependencies make the process more complicated. The ideal would be
if all changes could be validated by the preflight. This harder when
incorporating third party services or managing external configuration. Our
typical approaches have been to reduce the extra dependencies, keep the
contracts relatively stable or version the other components.

*Stability is paramount.* Most improvements to the preflight system are made
incrementally using pull requests which are validated by the preflights. As we
continue to iterate on the process we have tried to address any components
which are unstable. A common offender which were sensitive integration tests.
Slowly we fixed many o these tests and ensured the pass/fail would be a clear
indication whether your code should be merged or not.

Iterating
===============================================================================

It is safe to say we have learnt some lessons

* Remove Instability
* Complicated by external configuration

Thoughts:

Do I get numbers?

Master is more stable.
Committing without CI is taking matters into your own hands. You do not have to wait, but if you break the build you are responsible.
Overall we are a little slower, but we are much smoother. Everyone waits for their builds to finish.

Oddly local builds are less important. You can push then wait for the results. My workflow is more async.

Code reviews and builds are fully integrated. Some devs don't even want to look at it until they have passed.


Fixing breaks in master are longer. Reverting instead of rushing out more is recommended.