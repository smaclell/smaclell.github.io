---
layout: post
title:  "Exterminator 12 - Finding the Bottleneck"
date:   2015-06-21 23:53:07
tags: focus
---

Find the bottleneck. Fix it. Repeat as needed.

This week we continued wrapping up our release with some performance tuning.
Everything else was ready and we wanted to see if we could make it faster. It
was really easy to get started and I want to share some of what we did. Some
of the lessons I learnt are a cautionary tail and encouragement to dig deeper.

We were ready to release. All of our tests were passing. We had finished doing
testing with a large number of sample datasets. We found some the software was
a little slow for some tests.

**1. Find the bottleneck**

Since speed was our primary concern we
decided to focus on where the code was spending the most time. Our reasoning
was if we could find and shrink the most active parts of the code we could
make the whole process faster.

With the slower packages, we started by attaching the built in profiler in
Visual Studio to find the bottleneck. This uses a simple sampling mechanism
to see where the code is spending most of it's time.

<figure class="image-center">
	<img src="/images/ProfilerAttaching.png" />
	<figcaption>
	Profiling a running process or starting new profiling sessions is easy!
	</figcaption>
</figure>

We expected certain areas of the code were being called frequently. With
the performance data in hand we found the exact functions being called. We
found a few classes deep within our libraries which were very active.

The two primary hot areas were the children of the functions A and B.
These functions barely took up any time at all. This is why inclusive
samples (time spent in the function and children) is much larger than
the exclusive samples (only time spend in the function).

<div class="table-responsive image-center">
	<table class="table table-striped" style="margin: 0px auto; width: 75%">
		<caption>The Hot Path</caption>
		<col class="text-left" />
		<col class="text-right" style="width: 20%;" />
		<col class="text-right" style="width: 20%;" />

		<tr>
			<th>Function Name</th>
			<th>Inclusive Samples %</th>
			<th>Exclusive Samples %</th>
		</tr>
		<tr>
			<td class="text-left">Parent</td><td>92.77</td><td>0.09</td>
		</tr>
		<tr>
			<td class="text-left" style="padding-left: 5%">DetectDependencies</td><td>66.06</td><td>0.33</td>
		</tr>
		<tr>
			<td class="text-left" style="padding-left: 5%">HandleBadPaths</td><td>24.11</td><td>0.3</td>
		</tr>
	</table>
</div>

Next up we looked at the functions doing the most work. Clearly we are using
lots of regexes.

<div class="table-responsive image-center">
	<table class="table table-striped" style="margin: 0px auto; width: 75%">
		<caption>Functions Doing the Most Work</caption>
		<col class="text-left" />
		<col class="text-right" style="width: 28%;" />
		<col class="text-right" style="width: 12%;" />

		<tr>
			<th>Function</th>
			<th colspan="2">Exclusive Samples %</th>
		</tr>

		<!-- Widths are scaled based on the size of the largest item -->
		<tr>
			<td class="text-left">Regex.IsMatch(string)</td><td><b class="barchart" style="width: 100%">&nbsp;</b></td><td>41.01</td>
		</tr>
		<tr>
			<td class="text-left">Regex.Match(string,int)</td><td><b class="barchart" style="width: 30%">&nbsp;</b></td><td>12.10</td>
		</tr>
		<tr>
			<td class="text-left">Regex..ctor(string)</td><td><b class="barchart" style="width: 11%">&nbsp;</b></td><td>4.65</td>
		</tr>
		<tr>
			<td class="text-left">String.ToLowerInvariant()</td><td><b class="barchart" style="width: 5.8%">&nbsp;</b></td><td>2.38</td>
		</tr>
		<tr>
			<td class="text-left">Dictionary`2.TryGetValue(!0,!1&amp;)</td><td><b class="barchart" style="width: 5.7%">&nbsp;</b></td><td>2.34</td>
		</tr>
	</table>
</div>

**2. Fix It**

Based on how the regexes were used by the child methods of A we tried optimizing
our regexes and string manipulation. Instead of using regexes we made the checks
simpler and where possible combined operations. The newer code was
more complicated and would be more difficult to understand. We added [comments][comments]
explaining why the code had been updated.

With our first changes we then retested the performance. We were confident
everything still worked the same thanks to our automated tests, but needed
to know for sure if the performance was actually better.

Comparing the amount of time spent in functions called by A we were able to
increase the percentage of time spent in methods doing real work! As shown
by the inclusive percent for functions called by A, you can see we now spend
much less time in ``AddRange`` and proportionally more time in ``TryParse``.
Work done by ``TryParse`` is central to the algorithm we are using and so
spending more time in this method is expected.

<figure style="margin: 0px auto; width: 75%">
	<img style="float:left;" src="/images/DetectDependeniesBefore.png" />
	<img style="float:right;" src="/images/DetectDependeniesAfter.png" />
	<figcaption style="clear: both; text-align: center">Before and After</figcaption>
</figure>

**3. Repeat as needed**

With our new changes in place the bottleneck moved! The function B and it's
children were now the worst performers.

<div class="table-responsive image-center">
	<table class="table table-striped" style="margin: 0px auto; width: 75%">
		<caption>The Hot Path</caption>
		<col class="text-left" />
		<col class="text-right" style="width: 20%;" />
		<col class="text-right" style="width: 20%;" />

		<tr>
			<th>Function Name</th>
			<th>Inclusive Samples %</th>
			<th>Exclusive Samples %</th>
		</tr>
		<tr>
			<td class="text-left">Parent</td><td>91.22</td><td>0.12</td>
		</tr>
		<tr>
			<td class="text-left" style="padding-left: 5%">HandleBadPaths</td><td>45.04</td><td>0.3</td>
		</tr>
		<tr>
			<td class="text-left" style="padding-left: 5%">DetectDependencies</td><td>43.39</td><td>0.36</td>
		</tr>
	</table>
</div>

We repeated this process a few times addressing the next most important area.
After a while we started to have more and more trouble finding good places to
optimize and felt we had done enough.

The next set of optimizations would have been rewriting our Parser performing
the ``TryParse`` method. Doing so would have been a large undertaking and we
did not have enough time this iteration.

Hindsight is 20/20
===============================================================================

Sounds great right? Well ... not entirely. Our total improvement when all was
said and done was about 5%. Even those gains I am not totally sure of due to
how we captured the data.

We are not performance experts. We learnt just enough to be dangerous. With
our rough understanding of what we saw we began making changes. It is
problematic to jump to [root causes's][root] of problems without understanding
what is actually happening.

**Micro Optimizations Led to Micro Improvements**

I believe the micro-optimizations we made resulted in micro performance improvements.

**What about ...**

We were focusing solely on the amount of time spent within methods. What about
everything else? Garbage collectors and memory pressure are a big deal.

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
[root]: {% post_url 2015-03-04-lessons-learnt-while-finding-the-root-cause %}