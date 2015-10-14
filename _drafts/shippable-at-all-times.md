---
layout: post
title:  "Being Shippable At All Times"
date:   2015-09-29 22:37:07
tags: discusssions
---

We often talk about keeping our projects "shippable at all times". We have
adopted a different view about how to achieve this than many other teams we
work with. For most teams this means taking whatever is currently checked into
master and being able to release it at any point. For us we can ship the last
package we have fully tested. While the net result can be the same, I believe
the distinction between the two options is important.

Ideas:
Two aspects of being shippable at all times:

A) Choosing what to ship.
B) Producing code worth shipping.

Your code no good? You shouldn't choose to ship anything.
Master is always shippable? You can choose between alot more options.

We focus on choosing what to ship. It means you can always ship something when
you want to release. It is more important for us to know exactly what is in each
build and how it has been tested.

Other teams focus on keeping their master shippable at all times. This goes
above and beyond keeping your CI process green. No changes can be merged which
will hold you back from releasing at any second. The plus side is you have many
builds which could be shipped.


The Options
===============================================================================

As we see it teams do one of the following:

A) Try to keep master perfectly shippable at all times.
B) Try to know what they can ship right now.

The Differences
===============================================================================

So what is the big deal? Forcing teams to always have perfect master branch
puts much more pressure on every change. Everything must be perfectly tested
and validated before you can even consider merging it. This shifts the
mentality from small bite-sized changes to complete features which tend to all
flood in at the last minute.

On the contrary if master can be unstable or not perfect to release you can
plan your work differently. It becomes okay to merge little pieces instead of
complete feature. If it makes sense you defer manual testing a little bit
later. You might not want to ship the current changes and that is okay. Once
the changes are manually validated you can decide which package is ready.



  If it is okay to merge smaller pieces which are mostly validated automatically
or only partially implement the feature they support then you .
 Perfection is the enemy
of progress.

The Decision
===============================================================================