---
layout: post
title:  "Figuring Out Flaky Tests"
description: "The day before I went on vacation I walked through investigating issues I was having with a flaky test. We looked at isolating the test, looking at the timing and getting better information."
date:   2015-12-22 16:17:07
tags: testing troubleshooting chris
image:
  feature: https://farm1.staticflickr.com/213/462206324_1393a72c01_z.jpg
  credit: "Icarus by Steve Jurvetson - CC BY 2.0"
  creditlink: https://www.flickr.com/photos/jurvetson/462206324/
---

Recently, I noticed tests near code I worked on being flaky. Sometimes they
would fail and sometimes they would pass. There didn't seem to be any pattern.
For all I knew it changed based on the time of day. On my last day before
vacation, I decided to dig into the tests to find a root cause.

Start Obvious
===============================================================================

There are a number of obvious ways code can fail. My first stop was to read
the test and look for bad behaviour. This particular test was an integration
test which used the database to create/delete data for each test. Our tests
are run in parallel which further complicates how the tests can interact
with each other.

I found exactly where the code was failing:

{% highlight csharp %}
// Create item

// Copy the item to a new container

Item item = GetAllItems( ContainerId ).SingleOrDefault( x => x.Id == "Expected Id" )

// This was the failing assertion
Assert.IsNotNull( item );

// Delete the items
{% endhighlight %}

It was not clear what ``SingleOrDefault`` would do when there were no items in the list or too many. I tested
what happened when there were too many items and confirmed it fails a different
way. It explodes. This case would not fail the test in the way we were seeing.

Since the test I was review was an integration test I double checked to see if
the data could be deleted another way. The only place where the values from the
database were removed was in the test clean up. No dice.

I wanted to confirm running in parallel was not introducing an obvious race
condition. I double checked all of the data created by the test would be
isolated from other tests. The tests used standard libraries which are safe to
run in parallel. Nothing jumped out to me which would cause this test to
collide with others or itself.

At this point, I was stumped and was not sure how to continue. All the obvious
things had been ruled out. So far we have:

* Confirmed the failure
* Looked for other causes
* Checked race conditions

I needed more data to lead me in the right direction. Although I had ruled out
simple race conditions there could still be other problems. I was worried there
were still race conditions with other tests which would cause database
deadlocks. I decided to reach out to Chris who has lots of experience
investigating and fixing flaky tests.

[Repeat( 1000 )]
===============================================================================

Chris recommended confirming whether the test had intermittent issues when running alone.
He had a simple trick to repeat the test multiple times. Add the [Repeat][repeat]
attribute to the test.

This would essentially run the test 1000 times in a loop. If any test run fails
then the test fails. If the test had problems alone then this would easily show
them. Otherwise, we would have to continue looking elsewhere.

The test passed with flying colours. The search continued for other tests which
would have caused it to fail.

Into The Numbers
===============================================================================

Next step was digging into the history of the test. Was this the only test in
the class which was failing? How long did normal and exceptional test runs
take?

Thankfully we had hundreds of previous test runs. We determined this test
failed 6 times or 1.6% of all runs. This was not great.

With thousands of tests if there are enough of them like this our builds
would never pass. It is hard to keep this many tests solid without the
occasional flaky tests. This confirmed fixing the test was necessary.

Another trick Chris used was reviewing the duration of the test when it
passed compared to when it failed.

He looked for common times which would show a timeout occurring. Failing
abruptly after a fixed duration like 30, 60 or 90 seconds is a red flag.
Chris suspected another test could be causing our flaky test to timeout
and based on the numbers we confirmed the test was not timing out.

He checked to see if the failures occurred right away or much later. We found
the time for passing and failing tests were all over the map with no
discernible pattern. Had they been more consistent we could have looked for
other areas of the code which could cause it.

By the end of looking at the test statistics we were not much further. We ruled
out more potential causes.

Get More Data
===============================================================================

Once again we were stumped. We still thought there was some deadlock occurring,
but did not have a good way to reproduce it. With so many tests it would be
extremely hard to replicate the exact conditions causing the flaky test. We
thought we could run the tests again and again to better reproduce it.

We decided to gather more data on the tests. We wanted to disprove our hunch
regarding the deadlocks by trying to capture on the next time the tests failed.
Our co-worker, [Michael Swart][swart] a majestic database whisperer, gave us a
script to add additional tracing on the database server. The script was roughly the
same as this fantastic [script][script] from [brentozar.com][blocked].

Since only our tests run against this server the extra tracing is fine. On a
production database I am not sure if this same approach would be recommended.

Sadly we have yet to find the root cause. We decided to wait and see what
happens the next time the test fails. Although we did not reach the destination
I hope you enjoyed the journey. Until next time.

[repeat]: http://www.nunit.org/index.php?p=repeat&r=2.6
[swart]: http://michaeljswart.com
[blocked]: http://www.brentozar.com/archive/2014/03/extended-events-doesnt-hard/
