---
layout: post
title:  "Figuring Out Flaky Tests"
description: "The day before I went on vacation I walked through investigating issues I was having with a flaky test. We looked at isolating the test, looking at the timing and getting better information."
date:   2015-12-22 16:44:07
tags: testing troubleshooting chris
image:
  feature: https://farm5.staticflickr.com/4106/4957110777_88230c8926_b.jpg
  credit: "[4/365] Training By Pascal - Public Domain"
  creditlink: https://www.flickr.com/photos/pasukaru76/4957110777/
---

Recently, I noticed that some tests near code I had worked on were pretty
flaky. Most of the time they would pass, but occasionally they would fail. There
didn't seem to be any pattern. For all I knew, whether or not the test would pass
changed based on the time of day. On my last day before vacation, I decided to dig
into the tests to find out the root cause.

The Obvious Starting Place
===============================================================================

There are a number of obvious ways in which code can fail. My first stop was to read
the tests and surrounding code looking for bad behaviour. The particular test that I was examining was an
integration test which used the database to create/delete data for each test. Our
tests are run in parallel, which further complicates how the tests can interact with
each other.

The test case looked something like this:

{% highlight csharp %}
public class ItemCopyTests {

    [SetUp]
    public void Setup() {
        // Create original item and container
    }

    [Test]
    public void CopyingItemsToANewContainerCopiesEverything() {
        // Copy the item to a new container

        Item item = GetAllItems( NewContainerId )
                        .SingleOrDefault( x => x.Id == "Expected Id" );

        // This was the failing assertion
        Assert.IsNotNull( item );
    }

    [TearDown]
    public void TearDown() {
        // Delete all the items
    }

}
{% endhighlight %}

The failing assertion seemed like either the test or underlying operation was not
working. The item was not being copied as expected. I wanted to fix the test and
disprove that the code had a problem. My initial thought was to investigate the test
for issues.

It was not clear what ``SingleOrDefault`` would do when there was more than one item.
If there are no items, you get ``null``, which makes sense based on the API. I tested
what happens when there are too many items and confirmed that it fails in a different
way. It explodes. This case would fail the test with an exception and not at the
assertion like we were seeing.

Since the test was an integration test, I double checked to see if the data could be
deleted another way. The only place where the values from the database were removed
was in the test clean up. No dice.

I then wanted to confirm that running in parallel was not introducing an obvious race
condition. I double checked the test to ensure that all of the data created by the test would
be isolated from other tests. The tests used standard libraries which are safe to
run in parallel. Nothing jumped out to me which would cause this test to
collide with others or itself.

At this point, I was stumped and was not sure how to continue. All the obvious
things had been ruled out. So far I had:

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

Chris recommended confirming whether the test had intermittent issues when running
alone. He had a simple trick to repeat the test multiple times: Add the
[Repeat][repeat] attribute to the test.

This would essentially run the test 1000 times in a loop. If any test run fails,
the test fails. If the test had problems alone, this would easily show them.
Otherwise, we would have to continue looking elsewhere.

The test passed with flying colours. The search continued for other tests which
would have caused it to fail.

Into The Numbers
===============================================================================

Next step was digging into the history of the test. Was this the only test in
the class which was failing? How long did normal and exceptional test runs take?

Thankfully, we had hundreds of previous test runs. We determined that this test had
failed 6 times or 1.6% of all runs. This was not great.

With thousands of tests, if there are enough flaky tests with low percentages
like this one our builds
would never pass. It is hard to keep this many tests solid without the
occasional flaky tests. This confirmed fixing the test was necessary.

Another trick Chris used was reviewing the duration of the test when it
passed compared to when it failed.

He looked for common times which would show a timeout occurring. Failing
abruptly after a fixed duration like 30, 60 or 90 seconds is a red flag.
Chris suspected another test could be causing our flaky test to timeout,
but based on the numbers we confirmed that the test was not in fact timing out.

He checked to see if the failures occurred right away or much later. We found
the time for passing and failing tests were all over the map with no
discernible pattern. Had they been more consistent, we could have looked for
other areas of the code which could cause it.

By the end of looking at the test statistics, we were not much further. We ruled
out more potential causes.

Get More Data
===============================================================================

Once again we were stumped. We still thought there was some deadlock occurring,
but did not have a good way to reproduce it. With so many tests it would be
extremely hard to replicate the exact conditions causing the flaky test. We
thought we could run the tests again and again to better reproduce it.

We decided to gather more data on the tests. We wanted to disprove our hunch
about the deadlocks being the root cause by capturing them the next time the test failed.
Our co-worker, [Michael Swart][swart] a majestic database whisperer, gave us a
script to add additional tracing on the database server. The script was roughly the
same as this fantastic [script][blocked] from [brentozar.com][blocked].

Extra tracing was fine, since the database server was only being used to run tests.
 qOn a production database, however, I am not sure if the same approach would be recommended.

Sadly, we have yet to find the root cause. We decided to wait and see what
happens the next time the test fails. Although we did not reach the destination,
I hope you have enjoyed the ride. Until next time. Hi ho silver!

<hr />

*I would like to thank my lovely wife, [Angela][ange], for proofreading this post.
Up up and away, hi ho silver!*

[repeat]: http://www.nunit.org/index.php?p=repeat&r=2.6
[swart]: http://michaeljswart.com
[blocked]: http://www.brentozar.com/archive/2014/03/extended-events-doesnt-hard/
[ange]: http://macangela.tumblr.com
