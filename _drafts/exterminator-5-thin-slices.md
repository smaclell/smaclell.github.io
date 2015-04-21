---
layout: post
title:  "Exterminators Week 5"
date:   2015-04-27 00:09:07
tags: pull-requests exterminator
---

I have been running an experiment taking bigger changes and separating them
into many MANY small pull requests. What I am hoping to see is the individual
pull requests should be easier. Larger changes should still be possible and
be naturally built up each small pull request. Each pull request should be
shippable on their own.


During
the first few weeks with the [Exterminators][tribute] I noticed many of my pull
requests becoming quite large and complicated. The code reviews I was doing for
others were taking a long time and were included many changes. The reviews
helped improve the code, but feel like a bottleneck in the team's process.

Continuous Delivery is addictive and I have drank the Koolaid. With my previous
team we had been able to add a new feature and ship it into production later
the same day. All of the changes were small and built upon each other. Code
reviews were easier and could often be done quickly by anyone on the team.

While the Exterminators could not ship new features in a day, I thought I could
use the same approaches to break down larger features into smaller changes
which could be shipped independently or in sequence. My new habits of
[focus and quality][goals] would be readily applicable. I could focus intensely
on each small change and make sure I took small steps to larger changes in
order to reduce the risk introduced by each change.

The Candidate
===============================================================================

Ironically, when I started this new experiment I thought the defect I was
working on would be incredibly easy! Initially it looked like a few line change
at the most. I was fixing a defect similar to one we fixed in nearby code.
Adjusting the original fix to the new area didn't work.

Digging deeper into the problem I found even more issues and duplication.
Biting the bullet I decided I would refactor the code to have only one way to
perform the specific operation and fix the problem. At the same time I could
improve our test coverage and put a dent in our [legacy code][legacy].

I had found a candidate for using small pull requests to solve the a larger
problem. Each pull request would be easier to understand and bit by bit lead
to the overall solution.

Finding the Seams
===============================================================================

My first order of business was to find seams in the application to begin making
the refactoring and address the defect. I wanted points in the existing
architecture to make the change with minimal impact. This often involves where
to sections of code join together, like a welded seam TODO picture.

TODO insert a proper definition for seam http://www.informit.com/articles/article.aspx?p=359417&seqNum=2

TODO insert seam examples.

There are many potential seams 

I read thousands upon thousands of lines of code. Over time a picture emerged
with areas affected by the defect and surrounding areas where changes could be
introduced.

My first place was method controlling the logic responsible for the defect.
This was a gold mine. Everything I needed to do for the original fix could be
done right here.

I intentionally avoided other areas including the duplicate code I wanted to
refactor. These were a distraction for fixing the original defect and could
come later. By focusing on the code affected by the defect I could constrain
the first few pull requests.

Baby Steps
===============================================================================

The first steps were slow, but were enough to get me walking. I picked small
adjustments around my target seam to better understand the code and make future
changes safer. I added integration tests around the seam to make sure I did not
break anything and better understand the code. I refactored a particularly
confusing method into smaller pieces. I setup a few helper methods to access
data I would need.

Each of the changes were done in complete isolation. I tried to minimize their
impact on the existing code to reduce the risk they introduced. Very little of
the existing code was affected. Even for the refactoring I did I tried to keep
the majority of code intact, relying heavily on automated tools and small steps
to avoid breaking the existing code.

Things were going great and then our release date approached. The actual fix was
not ready. Not a problem. I wrapped up the changes I was making, we tested them
more thoroughly and shipped the first few parts.

Had I done the same changes all at once this would have been a much riskier
proposition. There would have been more affected areas and would have required
a lot more testing. Instead we tested the few updated components. I felt great
about my changes and had improved the integration tests.

Into the Brink
===============================================================================

With the release out of the way I picked up the pace. By this point I had the
complete plan for the change in my head and started to piece everything
together. I implemented my new changes beside the old code using TDD. Instead
of mixing my new updates with the existing classes I made new ones and tested
them into submission.

After a few more pull requests I was able to fix the defect and integrate my
changes.

Collision
===============================================================================

Dedupe
===============================================================================

What Did I Learn?
===============================================================================

TODO: Talk about how this was several weeks

Instead of having massive pull requests for
large chunks of work I have been trying to ma what if I broke it up into many MANY
little pieces. At the same time I have been trying to keep each piece shippable
and add up to the eventual story I am working on.

Shipping small slices. Want to increasely add value, but don't want to introduce risk.

Minimize the impact to existing code.
Reduce the risk. Safe changes.
Don't do very much.
Repeat.

Sketch up what you want to do. Cut it up. Do it.

Legacy code? Add your tests first!
Prototype it. Then throw it away.
Do your code beside the old code. Cut Over.
Test the snot out of what you are doing.
Separate refactoring.
Separate any setup steps.
Separate any clean up.
More testing when you cut in pieces.
The more the merrier!

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[goals]: {% post_url 2015-03-30-exterminators-2-focus-and-quality %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}