---
layout: post
title:  "Exterminators Week 5 - Thin Slices"
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

Continuous Delivery is addictive and I have drunk the Kool-Aid. With my previous
team we had been able to add a new feature and ship it into production later
the same day. All of the changes were small and built upon each other. Code
reviews were easier and could often be done quickly by anyone on the team.

While the Exterminators could not ship new features in a day, I thought I could
use the same approaches to break down larger features into smaller changes
which could be shipped independently or in sequence. Individual changes could be
broken down into small pull requests<sup id="reverse-ext-5-note-1"><a href="#ext-5-note-1">1</a></sup>. My new habits of
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

I had found a candidate for using small pull requests to solve a larger
problem. Each pull request would be easier to understand and bit by bit lead
to the overall solution.

I started out with the following principles to guide each and every pull
request I made:

1. Work in small shippable slices
2. Add customer value
3. Minimize risk

Finding the Boundaries
===============================================================================

My first order of business was to find boundaries in the application to begin
making the refactoring and address the defect. I wanted points in the existing
architecture to make the change with minimal impact. This often involves where
to sections of code join together, like a welded seam.

TODO replace the references to seams and update all of this.
TODO picture.
TODO: Review the book.
This is different than traditionally seams:

> “Seam”: A place where you can alter behavior in your program without editing
> in that place. (p. 31 and again on p. 36)

Not performing any edits to the existing code would be to restrictive. I would
try to leverage types, parameters and other natural seams throughout the
software, but would then take it one step further and adjust localized
behaviour around the defect.

I read thousands upon thousands of lines of code. Over time a picture emerged
with areas affected by the defect and surrounding areas where changes could be
introduced.

My first place was method controlling the logic responsible for the defect.
This was a gold mine. Everything I needed to do for the original fix could be
done right here. I quickly prototyped up a solution to make sure my plan would
work. The prototype was a confirmation I was on the right path and then I threw
it away so I could start with a clean slate and drive my development with
tests.

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

The changes were each done in complete isolation. I tried to minimize their
impact on the existing code to reduce the risk they introduced. Very little of
the existing code was affected. Even for the refactoring I did I tried to keep
the majority of code intact, relying heavily on automated tools and small steps
to avoid breaking the existing code.

Things were going great and then our release date approached. The actual fix was
not ready. Not a problem. I wrapped up the changes I was making, tested them as
a team and then shipped the first few pull requests.

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
changes. Some of additions tried to isolate the new functionality, whereas
others we created to highlight when new components were being integrated.
Another pull request was used to rename a common component. A pull request for
deleting old code that was no longer needed.

Changes were cruising along and reviews were going well. The other developers
were really getting into it. The collaboration was stellar. Right in the middle
of reviewing the work we hit a snag.

Collision
===============================================================================

Unknown to us another team was working in the exact same area. It is an easy
mistake to have happen and neither of us had considered the possibility of
this happening. With my small changes I had been impeding their work and for
the first time they won the merge race. This was the first time they had merged
before I was able to merge one of my pull requests.

At first I was stunned. We had been going full speed only to skip off the
tracks. It was disheartening, but we I knew were we close so I dug in and
kept going.

However, the more I looked at the other changes the better I felt. They had
carefully and meticulously been doing many of the same things I had been
trying to do, increase test coverage and improve the code. In fact there was
one file where another developer and I both had tried to improve the same
monster method in roughly the same way.

We regrouped and adjusted the remaining reviews based on their new changes.
Thanks to our small changes we were able to isolate the area to be updated.

We merged our final fixes and took a breather so the changes could be tested.
The testing went relatively smoothly and soon the many pull requests were ready
to be sent to our clients.

Dedupe
===============================================================================

We didn't stop there. We could have. It would have been easier. Instead I
wanted to finish the work we started and eliminate even more of the duplication
throughout the code. With the fix now complete we could return the duplication
that would have distracted us from fixing the original defect.

This time we tried to reduce how isolated the new changes were from the old
code. Instead we tried to break up the work into small functional units which
would eliminate all duplication in one area. Reviews would include more context
and showed new classes being used in the same pull request they were
introduced. This was still broken into several reviews which built on each
other to streamline the process.

We tried to preserve isolating refactoring and deletions. There were some of
the easiest reviews since they came near the end of the process and had a
single responsibility.

After these reviews were complete, I did one last review of everything together
and made a few more modifications. Some classes could be moved around, renamed
or have reduced visibility. The many incremental steps made seeing the overall
picture much harder. The final wrap up let us tie everything together and
review our finished product.

What Did I Learn?
===============================================================================

I feel like I learnt a lot throughout the process and had fun doing it. Using
thin slices and many code reviews like this was not easy, but I think it was
worth extra effort. The analysis, development, reviews and testing took weeks
to do. Each step of the way I would have felt comfortable shipping what we had
merged. Even now, weeks after the changes were wrapped up we are still learning
from the process and results.

Over time the goal for individual changes morphed into:

* Minimize the impact to existing code.
* Reduce the risk. Safe changes.
* Don't do very much at a time.
* Repeat.

TODO: Move this earlier as initial thoughts

It was surprising how as we kept going the momentum we gained. We have
continued trying this approach with other changes and it feels like we cannot
go fast enough.

* Legacy code? Start with tests!
* Prototype. Then throw it away.
* New code beside the old code then cut over.
* Automated testing covering your changes.
* Test throughout.
* Separate refactoring.
* Separate setup steps.
* Separate clean up.
* The more pull requests the merrier!

<br />

### Footnotes

<a id="ext-5-note-1" href="#reverse-ext-5-note-1">1.</a> I use the term
  *pull request* quite a bit throughout this post. *Pull requests* are a common
  process that looks a little like this:

  1. Have an idea
  2. Branch the code
  3. Do your work on the Branch
  4. Get the branch code reviewed (address any issues/recommendations)
  5. Merge the Branch
  6. Repeat

  For nice simple tutorial show the entire pull request process using plain git
  see [Effective pull requests][pr]. The article shows all the major mechanics
  for doing pull requests using branches and even a few advanced techniques and
  tools.

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[goals]: {% post_url 2015-03-30-exterminators-2-focus-and-quality %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[pr]: http://codeinthehole.com/writing/pull-requests-and-other-good-practices-for-teams-using-github/