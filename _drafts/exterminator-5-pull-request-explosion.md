---
layout: post
title:  "Exterminators Week 5 - Pull Request Explosion"
date:   2015-04-27 00:09:07
tags: pull-requests code-reviews exterminator shipping
image:
  feature: block-party.jpg
  credit: brett jordan CC BY 2.0 (cropped)
  creditlink: https://flic.kr/p/7tQx9e
  no-overlap: true
---

I have been running an experiment taking bigger changes and separating them
into many MANY small pull requests. I am hoping to see the individual pull
requests become easier and code to flow naturally. Larger changes should still
be possible and be composed of several pull requests.

During
the first few weeks with the [Exterminators][tribute] I noticed many of my pull
requests becoming quite large and complicated. The code reviews I was doing for
others were taking a long time. Many changes were included in each review and
it was hard to evaluate the different parts affected. The reviews help improve
the code and lead to a better product, but feel like a bottleneck in the team's
process.

I am addicted to everything Continuous Delivery and have drunk the Kool-Aid.
With my previous team we had been able to add a new feature and ship them into
production later the same day. We kept all our changes small and in small
shippable sets which built upon each other. Code reviews were easier and could
be done quickly by anyone on the team.

While the Exterminators cannot ship new features in a day, I thought I could
use a similar approach to break down larger features into small changes which
could be shipped independently or in a sequence. Individual changes could be
broken down into small pull requests<sup id="reverse-ext-5-note-1"><a href="#ext-5-note-1">1</a></sup>.

For those following along, this fit in great with my new habits of
[focus and quality][goals]. I could focus intensely on one change at a time
building toward larger larger improvements. As shown with my previous team,
smaller reviews can be done more quickly. The individual changes could be
tested and reviewed separately helping to reduce the risk of each change. Less
risk leads to better outcomes and higher quality releases for our customers.

The Candidate
===============================================================================

Ironically, when I started this new experiment I thought the defect I was
working on would be incredibly easy! Initially it looked like a few line change
at the most. I was fixing a defect similar to one we fixed in nearby code.
I made the same change only to find my fix didn't work!

Digging deeper into the problem I found even more issues and code duplication.
I decided while I fixed the original issue I would also bite the bullet and
refactor the code to have only one way to perform the specific operation. As an
added bonus I could improve our test coverage and put a dent in our [legacy code][legacy].

I had found a candidate for using small pull requests to solve a larger
problem. Each pull request would be easier to understand and bit by bit lead
to the overall solution.

Finding A Starting Point
===============================================================================

My first order of business was to decide where to start. I knew where the
defect was caused, but wanted to plan my work so I could minimize the impact of
my changes. This was important because it would be hard to get enough tests in
place to feel completely confident. Reducing what was modified would also help
me to focus on fixing the defect and refactoring to eliminate the duplication.

In short I wanted to find a place in the code where I could come in, make my
changes and get out without causing a mess.

I read thousands upon thousands of lines of code. Over time a picture emerged
surrounding the code causing the defect. It was a gold mine with everything I
needed to get started. I could focus my testing above where the defect was
caused and then surgically implement the fix. Everything I needed to do for
the original fix could be done right here.

To make sure I was on the right path I quickly prototyped up a potential
solution. The prototype worked and helped confirm my plan. Since I had taken
many shortcuts for the prototype I then threw it out. I would then start again
with my small pull requests accompanied by more automated tests.

Although my plan would address the defect and duplication, the starting
point I chose would avoided areas not affected by the defect. I wanted to focus
on fixing the defect without distractions. This starting point would let me fix
the defect directly. I could return later to the other areas and improve the
duplication.

Baby Steps
===============================================================================

The first steps were slow, but were enough to get me walking. I picked small
adjustments around my starting point to better understand the code and make future
updates safer. I added integration tests around the seam to make sure I did not
break anything. I refactored a particularly confusing method into smaller
pieces. I setup helper methods to access data I would need.

While I was first starting out I tried using the following principles to guide
my pull requests:

1. Work in small shippable slices
2. Add customer value
3. Minimize risk

In order to minimize risk the changes were each done in complete isolation. I
tried to minimize their impact on the existing code to reduce risk. Even for
the refactoring I did to break up the confusing method I tried to keep the
majority of code intact, relying heavily on automated tools and small steps.

Things were going great, and then our release date happened. The actual fix was
not ready. No problem. I wrapped up the changes I was making, tested them with
the team and then shipped the first few pull requests. Rather than rushing out
the fix we were able to slow down and make sure what we had already done was
fully ready.

Had I done the same changes all at once in one massive pull request this would
have been a much riskier proposition. Naturally, more code would have been
affected increasing the risk and what would need to be tested. Instead we
tested the few updated components and surrounding areas. I felt great about my
changes because they were low risk and improve the automated tests.

Into the Brink
===============================================================================

With the release out of the way, I picked up the pace. By this point I had the
complete plan for the change in my head and started to fill in the pieces. I
implemented my new changes beside the old code using TDD. Instead
of mixing my new updates with the existing classes I made new ones and tested
them into submission.

After a few more pull requests I was able to fix the defect and integrate my
changes. Some of additions tried to isolate the new functionality, whereas
others we created to highlight when new components were being integrated.
Another pull request was used to rename a common component. A pull request for
deleting old code that was no longer needed.

Changes were cruising along and reviews were going well. The other developers
were really getting into it. The collaboration was stellar. Suddenly we hit a
snag!

Collision
===============================================================================

Unknown to us another team was working in the exact same area. It is an easy
mistake to have and neither team considered the possibility of this happening.
For several days before my small changes had been impeding their work and for
the first time they merged before I did.

I was stunned. We had been going full speed only to be derailed at the last
minute. It was disheartening to say the least. We were so close to finishing.

The more I looked at the other changes the better I felt. They had
carefully and meticulously been doing many of the same things I had been
trying to do, increase test coverage and improve the code. In fact there was
one file where another developer and I both tried to improve the same
monster method in roughly the same way.

We regrouped and adjusted the remaining reviews based on the new changes.
Thanks to our small pull requests we were able to isolate what needed to be
updated.

After we were done our final reviews and updates we took a breather. This gave
time to full test the fixes. Overall the testing went fairly smoothly and soon
we were ready to send the fixes to our clients.

Dedupe
===============================================================================

We didn't stop there. We could have. It would have been easy. I wanted to
finish the work we started and eliminate the duplication I had seen earlier
throughout the code. With the fix now complete we could change focus back to
the duplication which would have distracted us from fixing the original defect.

This time we tried to reduce how isolated the new changes were from the old
code. Alternatively, we tried to break up the work into small functional units
to eliminate all duplication one area at a time. Reviews would include more context
and show new classes being used in the same pull request they were introduced.
From the earlier pull requests we had a few occasions where it was hard to
follow the flow across the many pull requests. The added context of these newer
reviews would help this problem by clearly showing how new code was to be used.

We tried to keep some refactoring and deletions in their own pull request separate
from cleaning up the duplication. These were some of the easiest reviews; they
focused on a single change each and as a result were simpler than the others.

After these code reviews were complete, I did one last scan of everything
together then did one final pull request to clean up some loose ends. Some
classes could be moved around, renamed or have reduced visibility. The many
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
refactoring and fix defects safely.

Each step of the way I would have felt comfortable shipping what we had merged.
Even when we were reset in the middle of our work we were able to adjust our
changes and continue. In fact having our pull requests interrupted by another
merge has made me believe doing small frequent pull requests makes dealing
with inevitable merge conflicts easier.

Even now, weeks after the changes were wrapped up we are still learning from
the process and ensuing discussions. I would definitely do it all over again
and have several times in the subsequent weeks. Others on the team have tried
variations on the same idea. Our reviews have been a very vibrant retrospective
topic and I am sure we will continue to explore the ideas we first tried here.

Would you try the same approach for your work? Would using more small pull
requests help you ship better? Give it a shot! I hope you like it.

<br />

### Footnotes

<a id="ext-5-note-1" href="#reverse-ext-5-note-1">1.</a> I use the term
  *pull request* quite a bit throughout this post interchangeably with code
  review. *Pull requests* are a common process that looks a little like this:

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