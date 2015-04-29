---
layout: post
title:  "Exterminators Week 5 - Pull Requests"
date:   2015-04-28 23:49:07
tags: pull-requests code-reviews exterminator shipping
image:
  feature: block-party.jpg
  credit: brett jordan CC BY 2.0 (cropped)
  creditlink: https://flic.kr/p/7tQx9e
---

I have been running an experiment taking bigger changes and separating them
into many MANY small pull requests. I am hoping to see the individual pull
requests become easier and code to flow naturally. Larger changes should still
be possible and be composed of several pull requests.

During
the first few weeks with the [Exterminators][tribute] I noticed many of my pull
requests becoming quite large and complicated. The code reviews I was doing for
others were taking a long time. Many changes were included in each review and
it was hard to evaluate the different parts affected. The reviews helped improve
the code and lead to a better product, but felt like a bottleneck in the team's
process.

I am addicted to everything Continuous Delivery and have drunk the Kool-Aid.
With my previous team we had been able to add new features and ship them into
production later the same day. We kept all our changes small and in
shippable sets which built upon each other. Code reviews were easier and could
be done quickly by anyone on the team without compromising quality.

While the Exterminators cannot ship new features in a day, I thought I could
use a similar approach to break down larger features into small changes which
could be shipped independently or as a sequence. Individual changes could be
broken down into small pull requests<sup id="reverse-ext-5-note-1"><a href="#ext-5-note-1">1</a></sup>.

For those following along, this fits in great with my
[focus and quality habits][goals]. I could focus intensely on one change at a time
building toward larger larger improvements. As shown with my previous team,
smaller reviews can be done more quickly. The individual changes could be
tested and reviewed separately helping to reduce the risk of each change. Less
risk leads to better outcomes and higher quality releases for our customers.

The Candidate
===============================================================================

Ironically, when I started this new experiment I thought the defect I was
working on would be incredibly easy! Initially it looked like a few line change
at the most. I was fixing a defect similar to one we encountered in nearby code.
I made the same change only to find it didn't work!

After digging deeper into the problem I found even more issues and code duplication.
I decided as I fixed the original issue I would also bite the bullet and
refactor the code to remove the duplication. As an added bonus I could improve
our test coverage to put a dent in our [legacy code][legacy].

With fixing this defect, I had found a candidate for using small pull requests to solve a larger
problem. Each pull request would bit by bit lead to the overall solution.

Finding A Starting Point
===============================================================================

My first order of business was to decide where to start. I knew where the
defect was caused, but wanted to plan my work so I could keep my changes safe.
This was important because it would be hard to get enough tests in place to
feel completely confident. Staying safe by isolating what was modified would
also help me to focus on fixing the defect and only refactoring to eliminate
the duplication without getting carried away.

In short I wanted to find a place in the code where I could come in, make my
changes and get out without causing a mess.

I read thousands upon thousands of lines of code. Over time a picture emerged
surrounding the code causing the defect. It was a gold mine and had everything I
needed to get started. I could focus my testing above where the defect was
caused and then surgically implement the fix. Everything I needed to do for
the original fix could be done right at the place I found.

To make sure I was on the right path I quickly prototyped up a potential
solution. The prototype worked and helped confirm my plan. Since I had taken
many shortcuts for the prototype I then threw it out. I would then start again
with small pull requests accompanied by automated tests.

Although my overall plan would address the defect and duplication, the starting
point I chose would avoided areas not affected by the defect and most of the duplication. I wanted to focus
on fixing the defect without distractions. This starting point would let me fix
the defect directly. I could return to the other areas later and deal with the
duplication.

Baby Steps
===============================================================================

The first steps were slow, but were enough to start walking. I picked small
adjustments at my starting point to help me better understand the code and make future
updates safer. I added integration tests around the affected methods to make sure I did not
break anything. I broke down a particularly confusing method into smaller
pieces. I setup helper methods to access data I would need.

In order to minimize risk the changes were done with as much isolation from
existing code as possible. Any unintended side effects could cause more defects
and I thought the smaller the impact the better it would be. Even while
breaking up the confusing method I tried to keep the
majority of code intact, relying heavily on automated tools and small steps.

Things were going great, and then our release date happened. The actual fix was
not ready. No problem. I wrapped up the changes I was making, tested them with
the team and then shipped the first few pull requests. Rather than rushing out
the fix we were able to slow down and make sure what we had already done was
fully ready. I had planned for this eventuality and kept all the pull requests
shippable.

Had I done the same changes all at once in one massive pull request this would
have been a much riskier proposition. Naturally, more code would have been
affected increasing the risk and what would need to be tested. Instead we
tested the few updated components and surrounding areas. I felt great about my
changes because they were low risk and surrounded by automated tests.

Into the Brink
===============================================================================

With the release out of the way, I picked up the pace. By this point I had the
complete plan for the change in my head and started to fill in the pieces. I
implemented my new changes beside the old code using TDD. Instead
of mixing my new updates with the existing classes I made new ones and tested
them into submission.

After a few more pull requests I was able to fix the defect and integrate my
changes with the rest of the system. Some of additions tried to isolate the new functionality, whereas
others were created to highlight when new components were being integrated.
Another pull request was used to rename a common component. Near the end I
added a pull request to delete obsolete code.

Changes were cruising along and reviews were going well. The other developers
were really getting into it. The collaboration was stellar. Then suddenly we hit a
snag!

Collision
===============================================================================

Unknown to us another team was working in the exact same area. It is an easy
mistake to make and neither team considered the possibility of this happening.
For several days before this happened, my small changes had been impeding their work and for
the first time they merged before I did.

I was stunned. We had been going full speed only to be derailed at the last
minute. It was disheartening to say the least. We were so close to finishing.

The more I looked at the other changes the better I felt. They had
carefully and meticulously been doing many of the same things I had been
trying to do, increase the test coverage and improve the code. In fact, the
other developer also tried to tidy up the confusing method I broke down using
a similar approach.

We regrouped and adjusted the remaining reviews based on the conflicting changes.
Thanks to our small pull requests we were able to isolate what needed to be
updated and then continue.

After we were done our final reviews and updates we took a breather. This gave
time to full test the fixes. Overall the testing went fairly smoothly and soon
we were ready to ship.

Dedupe
===============================================================================

We didn't stop there. We could have. It would have been easy. I wanted to
finish the work we started and eliminate the duplication I had seen earlier.
With the fix now complete we could switch back to work on the duplication we
had found.

This time we tried to reduce how isolated the new changes were from the old
code. Alternatively, we tried to break up the work along functional units
to eliminate all duplication in one area at a time. Reviews would include more context
and show new classes being used in the same pull request they were introduced.
The earlier pull requests had a few occasions where it was hard to
follow the changes flow across the many pull requests. The added context of these newer
reviews would help this problem by clearly showing how new code was to be used.

Like before, we tried to keep some refactoring and deletions in their own pull request separate
from cleaning up the duplication. These were some of the easiest reviews because they
focused on a single change each and as a result were simpler than the others.

After these code reviews were complete, I did one last scan of everything
merged together then did one final pull request to clean up some loose ends. Some
classes could be moved around, renamed or have their visibility reduced. The many
incremental steps made seeing the overall picture much harder. The final clean
up let us tie everything together and review the finished product.

What Did I Learn?
===============================================================================

I feel like I learnt a lot throughout the process and had fun doing it.

Over time I started to develop some general guidelines when creating each pull
request. These came from going through the process and helped provide direction
for the individual changes.

* Balance impact to existing code and establishing a context.
* Reduce the risk and make safe changes.
* Don't do very much at a time.
* Solve one part of the problem. Repeat.

Using small pull requests and many code reviews helped focus our development.
We gained momentum as we kept going and were able to streamline the changes.
Despite working in small increments, we managed to perform a moderate
refactoring and fix defects safely. The code is better off thanks to the work
we did and has better test coverage.

Each step of the way I would have felt comfortable shipping what we had merged.
Even when we were reset in the middle of our work we were able to adjust our
changes and continue. In fact having our pull requests interrupted by another
merge has made me believe doing small frequent pull requests makes dealing
with merge conflicts easier.

Even now, weeks after the changes were wrapped up we are still learning from
the experiment and ensuing discussions. I would definitely do it all over again
and have several times in the subsequent weeks. Others on the team have tried
variations on the same idea. Our reviews have been a very vibrant retrospective
topic and I am sure we will continue to explore the ideas we first tried here.

Would you try the same approach for your work? Would using small pull
requests help you ship better? Give it a shot! I hope you like it.

<br />

### Footnotes

<a id="ext-5-note-1" href="#reverse-ext-5-note-1">1.</a> I use the term
  *pull request* quite a bit throughout this post interchangeably with code
  review. *Pull requests* are a common process that looks a little like this:

  1. Have an idea
  2. Branch the code
  3. Do your work on the Branch
  4. Get the branch code reviewed (and address any issues/recommendations)
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
