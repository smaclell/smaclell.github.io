---
layout: post
title:  "Exterminator 12 - Finding the Bottleneck"
date:   2015-06-21 23:53:07
tags: focus
---

Find the bottleneck. Fix it. Repeat as needed.

This week we continued wrapping up our release with some performance tuning.
Everything else was ready and we wanted to see if we could make it faster. It
was really easy to get started and I want to share some of what we did.

We were ready to release. All of our tests were passing. We had finished doing
testing with a large number of sample datasets. We found some that were not as
fast as we would have liked.

**1. Find the bottleneck**

With the slower packages, we started by attaching the built in profiler in
Visual Studio to find the bottleneck. Since speed was our primary concern we
decided to focus on where the code was spending the most time. Our reasoning
was if we could find and shrink the most active parts of the code we could
make the whole process faster.

TODO: Insert an image setting up the profiler.

We had expected certain areas of the code were being called frequently. With
the performance data in hand we found the exact functions being called. We
found a few classes deep within our libraries which were very active.

TODO: Show a trace with some slow code.

**2. Fix It**

Our code used a variety of regexes to match strings. We switched many of the
regexes to simpler checks and combined several operations. The newer code was
more complicated and would be more diffult to understand. We added [comments][comments]
explaining why the code had been updated.

With our first changes we then retested the performance. We were confident
everything still worked the same thanks to our automated tests, but needed
to know for sure if the performance was actually better. Based on our new
changes the code was much much faster. Huzzah!

**3. Repeat as needed**

With our new changes in place the bottleneck moved! There were more places in
the same class to improve. We repeated this process a few times until we did
not have anything else we could do to the #1 slow class.

Pretty quickly the class we were working on was no longer the slowest part
of the system. We then repeated the process again with the next class we had
found.

After a while we started to have more and more trouble finding good places to
optimize and felt we had done enough.

Your Turn
===============================================================================

This was lots of fun and helped improve our product. I was surprised at just
how easy it was to get started. We now had an even better product which was
stable as before, but now faster.

TODO: Talk about how we found the #1 place to improve the processing HtmlParsing!

Go forth and speed up your code. Find the bottleneck. Fix it. Repeat as needed.

<hr />

<div class="disclaimer">
<p>
I am not a performance expert. This is a story of how we approach our improving
the performance of a very specific piece of code.
</p>
<p>
If performance is essential for your application, you should test it and
improve it often. For our application we already had a solid baseline and were
trying to get better.
</p>
</div>

[comments]: {% post_url 2015-04-07-exterminator-3-on-comments %}
