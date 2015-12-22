---
layout: post
title:  "Figuring Out Flaky Tests"
description: "The day before I went on vacation I walked through investigating issues I was having with a flaky test. We looked at isolating the test, looking at the timing and getting better information."
date:   2015-12-18 1:17:07
tags: tests troubleshooting chris
---

Recently, I noticed tests near code I worked on being flaky. Sometimes they
would fail and sometimes they would pass. There didn't seem to be any pattern.
For all I knew it changed based on the time of day. On my last day before
vacation I decided to dig into the tests to find a root cause.

Start With Obviously
===============================================================================

There are a number of obvious ways code can fail. My first stop was to read
through what was there and look for bad behaviour.

I found exactly where the code failed:

{% highlight csharp %}

{% endhighlight %}

I tried reading the code
to look for obvious problems with no luck. 
