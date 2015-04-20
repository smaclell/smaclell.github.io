---
layout: post
title:  "Exterminators Week 4 - DAMP Unfiltered AAA"
date:   2015-03-30 00:09:07
tags: unit-testing testing exterminator
---

A standard unit testing pattern is Arrange, Act and Assert or AAA. As
an [Exterminator][tribute], I have been spending lots of time reading and
writing unit tests. It is critical to clearly show what is being validated
by each unit test. Duplication between tests is tolerable to improve
readability.

I want to write easy to understand tests. Each test should have enough context
so you can learn what it is testing by reading little more than the test body.
You shouldn't need to read the entire file or many surrounding functions to
learn what is being tested.

AAA Recap
===============================================================================

The ideal for me would be to have all of the tests follow the AAA pattern.
In case you don't know what AAA is here is a brief description from the
[c2 wiki][c2-aaa]:

> 1. **Arrange** all necessary preconditions and inputs.
> 2. **Act** on the object or method under test.
> 3. **Assert** that the expected results have occurred.

Nothing to crazy here. Sticking to these simple sections clarifies
your tests dramatically. When tests violate this pattern they look like they
don't belong. The AAA pattern has several benefits, including highlighting what
is being tested by separating it from the setup and assertions.

To make it all crystal clear, here is a simple test following the AAA pattern:

{% highlight csharp %}
[TestFixture]
public class HashSetTests {

	[Test]
	public void Add_NewValue_ReturnsTrue() {
		HashSet<int> hash = new HashSet<int>();

		bool added = hash.Add( 1 );

		Assert.IsTrue( added );
	}
}
{% endhighlight %}

It is pretty clear I am testing ``HashSet<T>.Add( T item )`` and the
setup/assertions used to verify the correct behaviour.

If that is not enough of a recap I would encourage you to read
"[The fundamentals of unit testing : Arrange, Act, Assert][fundamentals]" by
Mark Simpson. I found it while writing this post and it provides a more detailed
review of the concept. It also inspired the example above; although I think
``HashSet<T>`` is cooler than ``Stack<T>``.

Okay, now back to the post.

Trouble in Paradise
===============================================================================

Maintaining clean AAA tests starts to break down for troublesome classes
[never design to be tested][legacy] and growing duplication throughout the
tests.

Thinking of how to test the untestable is a fun challenge. You need to approach
the problem differently than most development. It is not all spoils of war and
glory. Sometimes it downright nasty and feels worse than before.
[Too often mock objects are needed][mocks-smell] in order to pry classes apart.

Duplication throughout tests is hard to avoid. Groups of tests often have
similar setup or assertions. This is inevitable when exercising multiple
cases sharing common logic. As the tests grow it becomes important to reduce
the complexity and duplication without obscuring what is being tested.

One extreme to maintain being able to glance at a test and know exactly what is
doing would be to put all of the setup and logic required in the test itself.
Down this road are madness and a monstrous unmaintainable mess. Many tests would
be nearly identical and simple changes could easily break many tests as once.

Another extreme would be to extract all the setup or assertions into separate
methods. While this cuts down on the duplication it becomes harder to see what
each test is doing. Exactly what is happening becomes hidden behind the helper
methods. I think there are approaches here that can work better and still
reveal what the tests are validating. It is important to strike a balance so
the tests have less duplication, but what is being tested is still apparent.

You can extract assertions or setup into methods, but it will ultimately make
the tests just a little bit harder to follow. Using too many data driven tests
will hide the setup from each test case. Mocks will bloat your tests and
complicate the setup process. You are stuck in a hard place.

Double Down on AAA
===============================================================================

With legacy code I think it is even more important to double down on making
what is being tested clear by using the AAA pattern. The code is probably
hard enough to understand on its own. Simple tests with easy to understand
setup, actions and assertions are a good first step at breaking down
challenging legacy code.

<div style="margin: 1em" class="pull-right">
<a href="http://stackoverflow.com/users/912685/chris-edwards">
<img
	src="http://stackoverflow.com/users/flair/912685.png"
	width="208"
	height="58"
	alt="profile for Chris Edwards at Stack Overflow, Q&amp;A for professional and enthusiast programmers"
	title="profile for Chris Edwards at Stack Overflow, Q&amp;A for professional and enthusiast programmers" />
</a>
</div>

While thinking about the tradeoffs between reducing duplication and clean tests
I found this phenomenal answer to ["What does “DAMP not DRY” mean when talking about unit tests?"][so]
by [Chris Edwards](http://stackoverflow.com/users/912685/chris-edwards)
(edited by [Ian Ringrose](http://stackoverflow.com/users/57159/ian-ringrose)) on Stack Overflow:

> **It's a balance, not a contradiction**
>
> DAMP and DRY are not contradictory, rather they balance two different aspects
> of a code's *maintainability*. Maintainable code (code that is easy to change)
> is the ultimate goal here.
>
> **DAMP (Descriptive And Meaningful Phrases) promotes the readability of the code.**
>
> To maintain code, you first need to understand the code. To understand it,
> you have to read it. Consider for a moment how much time you spend reading
> code. It's a lot. *DAMP increases maintainability by reducing the time
> necessary to read and understand the code.*
>
> **DRY (Don't repeat yourself) promotes the [orthogonality][orthogonality] of the code.**
>
> Removing duplication ensures that every concept in the system has a single
> authoritative representation in the code. A change to a single business
> concept results in a single change to the code. *DRY increases
> maintainability by isolating change (risk) to only those parts of the system
> that must change.*
>
> **So, why is duplication more acceptable in tests?**
>
> Tests often contain inherent duplication because they are testing the same
> thing over and over again, only with slightly different input values or setup
> code. However, unlike production code, this duplication is usually isolated
> only to the scenarios within a single test fixture/file. Because of this, the
> duplication is minimal and obvious, which means it poses less risk to the
> project than other types of duplication.
>
> Furthermore, removing this kind of duplication reduces the readability of the
> tests. The details that were previously duplicated in each test are now
> hidden away in some new method or class. To get the full picture of the test,
> you now have to mentally put all these pieces back together.
>
> Therefore, since test code duplication often carries less risk, and promotes
> readability, its easy to see how it is considered acceptable.
>
> *As a principle, favor DRY in production code, favor DAMP in test code. While
> both are equally important, with a little wisdom you can tip the balance in your favor.*

The tests I was reading and writing were too DRY and the meaning was being lost
due to the heavy refactoring. DAMPer tests and strictly using the AAA pattern
would have made the tests easier to follow and maintain. In this case
tolerating more duplication so the tests make more sense is justified. Just
don't let the duplication sneak into your production code.

In several cases I went back with the original developer and worked with them
to write more DAMP tests and really focus on keeping the AAA pattern. The
tests were much easier to understand. Through the process we found a simpler
way to implement the design and brought that back to the code. With the
original tests I don't think we would have seen this opportunity.

I tried looking at my own tests to make sure they showcased what was being
tested. For some this mean better names or shifting how common setup was
performed. In all cases I felt when tests aligned better with the AAA pattern
they were easier to understand.

Your Turn
===============================================================================

Unit testing can be great fun, prevent defects and grow your design. Using the
AAA pattern effective will lead to better tests. Even though legacy code can
make testing much harder I think it is well worth it.

I challenge you to write all of you tests using the AAA pattern. Stay DAMP and
watch out when things get too DRY. I think you will like how much easier to
understand your tests become.

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[c2-aaa]: http://c2.com/cgi/wiki?ArrangeActAssert
[fundamentals]: http://defragdev.com/blog/?p=783
[mocks-smell]: http://devblog.avdi.org/2011/09/06/making-a-mockery-of-tdd/
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[so]: http://stackoverflow.com/questions/6453235/what-does-damp-not-dry-mean-when-talking-about-unit-tests
[orthogonality]: http://www.artima.com/intv/dry.html
