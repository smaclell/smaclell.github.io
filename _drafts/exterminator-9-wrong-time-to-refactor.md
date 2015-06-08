---
layout: post
title:  "Exterminators Week 9 - The Wrong Time To Refactor"
date:   2015-06-04 23:52:07
tags: refactoring releases exterminator
---

This week I picked the wrong time to refactor. It was the day before our
release was due and we needed to wrap things up. We decided to not ship my
changes and I think that was the right choice.

We were fixing a bug. The problem affects multiple areas. You can use roughly
the same fix in each spot. What do you do?

1. Consolidate logic for the fix in one place, then call the updated logic as needed.
2. Repeat the fix as needed in each area.

TODO contrast picture, 1 big center with little dots outside or larger dots with no center

Normally, I would try to always pick option 1. I can test the change in one
place. Code reviews can be a little cleaner since you can consolidate the logic
required for the change. Either option involves a small change in the places
affected by the issue.

I say *normally* because this week the normal decision making processes changes.
People get tense and uptight the closer our shipping deadline nears. They want
to slow down what changes are made and be confident we are not introducing last
minute bugs. This is a good idea. Rushing in code you think is amazing, but is
secretly carrying the plague is not a good idea.

We had option 2. ready to go with a few days to spare and were happily
reviewing it. It fixed an important defect we wanted to ship on time. The
change was ready to be merged and all our initial testing looked good.

I decided I would try to implement option 1. and beat the release deadline.
There were some opportunities for consolidating the fix and reduce duplication.
Within a short while I had a pull request ready and was ready to be reviewed.
My new changes were ready with the deadline fast approaching.

TODO image of someone beating a finishline.

The code review looked okay on the surface, but was more complicated than the
previous fix we had already been testing. There were unit tests covering the
consolidated code and no tests covering the individual areas changed. The
original change did not have tests, but issues would be isolated to each area
updated and it was felt we could test them easily manually.

We liked how the new change had more tests. Our major concern was how close the
deadline was and whether we had enough time to fully test it.

We decided not to ship the changes. Rather than put the release at risk we
decided to wait and apply them the next release. This meant we could calmly
make all the changes we wanted to without the release looming over us.

I think this was the right decision and would do it again in the heartbeat.
While I think craftsmanship and clean code is important I value shipping
solid releases on time more. Do your customers care if you have the perfect
unit tests? No! They care when you break things. We already had the defect
fixed and so did not need my extra refactoring.

Several weeks later we went back and revisited the code. We added something
like my attempt to consolidate the logic. The second time we reviewed the code
we found better ways to break it down than my rushed first attempt.

I feel like I learnt that there are wrong times to refactor based on timing and
business needs. Next time your reach the end of the release and have an amazing
idea for how to clean up the code, think again.