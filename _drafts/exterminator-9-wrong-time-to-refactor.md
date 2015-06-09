---
layout: post
title:  "Exterminators Week 9 - The Wrong Time To Refactor"
date:   2015-06-04 23:52:07
tags: refactoring releases exterminator
---

This week I picked the wrong time to refactor. It was the day before our
release was due and we needed to wrap things up. We decided to not ship my
changes and I think waiting was the right choice.

We were fixing a bug. The problem affected multiple areas. You could use roughly
the same fix in each spot. What do you do?

1. Consolidate logic for the fix in one place, and then call the updated logic as needed. (Left)
2. Repeat the fix as needed in each area. (Right)

<figure class="image-center">
	<img
		title="Consolidate the logic or repeat the fix everywhere?"
		alt="On the left a circle encircled ny eight smaller circles. On the right there is a circle of eight circles larger than those on the left."
		src="{{ site.url }}/images/Consolidated.png" />
</figure>

Normally, I would try to pick option 1. You can test the change better
and make updates easier in the future.
Code reviews can be a little cleaner since you can consolidate the logic
required for the change. Either option involves a small change in the places
affected by the issue with more changes to the affected areas with option 2.

I say *normally* because this week the normal decision making did apply.
People get tense and uptight the closer the release deadline nears. They want
to slow down what changes are being made and be confident no last minute bugs are
introduced. This is a good idea. Rushing code in at the last minute you think is
amazing can blind you to the fact it is secretly carrying the plague.

We had option 2. ready to go with a few days to spare and were happily
reviewing it. It fixed an important defect we wanted to ship on time. The
change was ready to be merged and all our initial testing looked good.

I decided I would try to refactor the fix to be closer to option 1. and beat the release deadline.
There were some opportunities for consolidating the fix and reduce duplication.
Within a short while I had a pull request ready for review. The release deadline
was approaching fast.

<figure class="image-center">
	<a href="https://www.flickr.com/photos/comedynose/9320845849" title="Project 365 #200: 190713 The Finishing Line by Pete, on Flickr">
		<img src="https://c4.staticflickr.com/8/7443/9320845849_4ea7da5a4a_z.jpg"
			width="640"
			height="426"
			alt="A picture of numbers at a finishline">
	</a>
	<figcaption>
		Project 365 #200: 190713 The Finishing Line by <a href="https://www.flickr.com/photos/comedynose/">Pete</a>,
		used under <a rel="license" href="https://creativecommons.org/licenses/by/2.0/">Creative Commons 2.0 BY</a>
	</figcaption>
</figure>

My code review looked okay on the surface, but was more complicated than the
previous fix. There were unit tests covering my pull request and the
consolidated code, but no tests covering the individual areas changed. Even
though the previous fix did not have tests, we felt confident any issues
would be isolated to the updated areas. Each of the affected areas could be
tested manually.

We liked how my new change had more tests. Our major concern was how close the
deadline was and whether we had enough time for thorough testing.

We decided not to ship my updated code. Rather than put the release at risk we
decided to wait and do the refactoring in the next release. This meant we could calmly
make all the changes we wanted to without the pressure of an imminent release looming over us.

I think this was the right decision and would do it again in the heartbeat.
While I think craftsmanship and clean code are important I value shipping
solid releases without drama more. Do your customers care if you have the perfect
unit tests? No! They care when you break things. We already had the defect
fixed and did not need my extra refactoring.

Several weeks later we went back and revisited the code. We added something
like my refactoring. The second time we reviewed the code we found better ways
to break down the duplication than my rushed first attempt.

From this experience, I learnt there are wrong times to refactor based on
release timing and the business needs. Next time your reach the end of the
release and have an amazing idea for how to clean up the code, please wait
until the next release.
