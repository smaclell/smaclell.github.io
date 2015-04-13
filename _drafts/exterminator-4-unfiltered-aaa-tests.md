---
layout: post
title:  "Exterminators Week 4 - Unfiltered AAA"
date:   2015-03-30 00:09:07
tags: unit-testing testing exterminator
---

The gold standard unit test layout is Arrange, Act and Assert or AAA. As
an [Exterminator][tribute], I have been spending lots of time reading and
writing unit tests. It is critical to clearly show what is being validated
by each unit test. What is important to each test changes and techniques to
reduce duplication can reduce clarity.

I want to write easy to understand tests where each provides enough context for
what is being tested. You shouldn't need to read the entire file or many
surrounding functions to learn what is being tested. If a test fails, any other
developer should be able to figure out what is being tested by reading the test
name, the class name and test body.

AAA Recap
===============================================================================

The ideal for me would be to have all of the tests follow the AAA pattern test
setup. In case you don't know what AAA is here is a brief description from the
[c2 wiki][c2-aaa]:

> 1. **Arrange** all necessary preconditions and inputs.
> 2. **Act** on the object or method under test.
> 3. **Assert** that the expected results have occurred.

Nothing to crazy here, but trying to stick to these simple sections clarifies
your tests dramatically. Anything tests violating this pattern look like they
don't belong. Trying to have all tests keep these three basic sections has the
benefits of highlighting what is being tested by separating it from the setup
and assertions.

To make it all crystal clear here a simple test following the AAA pattern:

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

If that is not enough of a recap I would encourage you to read
"[The fundamentals of unit testing : Arrange, Act, Assert][fundamentals]" by
Mark Simpson. I found it while writing this post and it provides a detailed
review of the concept. It also inspired the example above, although I want to
point out ``HashSet<T>`` is cooler than ``Stack<T>``.

Okay, now back to the post.

Trouble in Paradise
===============================================================================

This starts to break down for troublesome classes that were [never design to be tested][legacy]
and duplication throughout the tests.

Thinking of how to test the untestable is a fun challenge. You need to approach
the problem different. It is not all spoils of war and glory. Sometimes it
downright nasty and feels worst than before. [Too often mock objects are needed][mocks-smell]
in order to pry apart classes and objects.

Duplication throughout tests is hard to avoid. Groups of tests often have
similar setup or assertions. This can be inevitable when exercising multiple
cases which share a common logic. As tests grow it becomes important to reduce
the complexity and duplication without sacrificing clarity.

One extreme to maintain being able to glance at a test and know exactly what is
doing would be to put all of the setup and logic required in the test itself.
Down this road is madness and a monstrous unmaintainable mess. Many tests would
be nearly identical and simple changes could easily break many tests as once.

Another extreme would be to extract all the setup or assertions into separate
methods. While this cuts down on the duplication it becomes harder to see what
each test is doing. Exactly what is happening becomes hidden behind the helper
methods. I think there are approaches here that can work better and still
reveal what the tests are validating. It is important to strike a balance so
the tests have less duplication, but what is being tested is still readily
apparent.

Double Down
===============================================================================

With legacy code and duplication throughout code I think it is even more
important to double down on making tests clear by using the AAA pattern. The
easier it is to understand what is being tested despite the challenges
presented by more complicated code. You should double down on making sure the
different AAA sections of your tests can be easily understood.

What are some things we can do about it?

**1. Mute the unnecessary**

Refactor or remove repeated setup not essential to the tests. An objects where
any possible value would be valid for the test as long as it is consistent. If
possible I try to move these objects out of the test completely or use factory
methods to create them.

TODO: Think of a better example

{% highlight csharp %}
[TestFixture]
public class PersonRepositoryTests {

	private static Person Anyone = new Person {
		FirstName = "Any",
		LastName = "One"
	};

	[Test]
	public void Save_AnyPerson_NowContainsPerson() {
		PersonRespository repository = new PersonRepository();

		repository.Save( anyone );

		CollectionAssert.Contains( person, repository.FindPerson( anyone) );
	}
}
{% endhighlight %}

**2. Reduce your mocks**

In my journey to use fewer and fewer mocks throughout my tests I am finding my
test setup is often much simpler. Where I would normally use a complicated mock
object I am now favouring simple fakes.

Recently I faked a series of small interfaces used throughout many tests. This
allowed me to use the same fakes many places throughout the test suite and
vastly simplify the setup. Before using the fakes I had a series of
interrelated mocks that were had to follow and difficult to configure.
Switching to the fakes and allowing them to perform similar to an actual
implementation led to better tests.



In thinking about this problem I have been trying a few different techniques to
clean up my tests. They are not perfect, but I think the tests are getting
better.

Data Driven Tests


TODO:	Write less, show more code.
		Put the actual calendar implementation in the after section

TODO: Another good example is a bank account.

{% highlight csharp %}
using System;
using NUnit.Framework;

[TestFixture]
internal class CalendarTests {

	[Test]
	public void IsFree_WithNoEvents_ReturnsTrue() {
		Calendar calendar = new Calendar();

		DateTime anytime = DateTime.Now;
		bool isFree = calendar.IsFree( anytime )

		Assert.IsTrue( isFree );
	}

	[Test]
	public void IsFree_WithEventAfter_ReturnsTrue() {
		DateTime anytime = DateTime.Now;

		Calendar calendar = new Calendar();
		calendar.Add(
			new Event(
				anytime.AddMinutes(2),
				anytime.AddMinutes(4)
			)
		);

		bool isFree = calendar.IsFree( anytime )

		Assert.IsTrue( isFree );
	}

	[Test]
	public void IsFree_WithEventBefore_ReturnsTrue() {
		DateTime anytime = DateTime.Now;

		Calendar calendar = new Calendar();
		calendar.Add(
			new Event(
				anytime.AddMinutes(-4),
				anytime.AddMinutes(-2)
			)
		);

		bool isFree = calendar.IsFree( anytime )

		Assert.IsTrue( isFree );
	}

	[Test]
	public void IsFree_WithOverlappingEvent_ReturnsFalse() {
		DateTime anytime = DateTime.Now;

		Calendar calendar = new Calendar();
		calendar.Add(
			new Event(
				anytime.AddMinutes(-1),
				anytime.AddMinutes(1)
			)
		);

		bool isFree = calendar.IsFree( anytime )

		Assert.IsFalse( isFree );
	}

	[Test]
	public void IsFree_WithOverlappingEventStart_ReturnsFalse() {
		DateTime anytime = DateTime.Now;

		Calendar calendar = new Calendar();
		calendar.Add(
			new Event(
				anytime,
				anytime.AddMinutes(1)
			)
		);

		bool isFree = calendar.IsFree( anytime )

		Assert.IsFalse( isFree );
	}

	[Test]
	public void IsFree_WithOverlappingEventEnd_ReturnsFalse() {
		DateTime anytime = DateTime.Now;

		Calendar calendar = new Calendar();
		calendar.Add(
			new Event(
				anytime.AddMinutes(-1),
				anytime
			)
		);

		bool isFree = calendar.IsFree( anytime )

		Assert.IsFalse( isFree );
	}

}

internal class Event {
	private readonly DateTime m_start;
	private readonly DateTime m_end;

	public DateTime Start { get { return m_start; } }
	public DateTime End { get { return m_end; } }

	public Event( DateTime start, DateTime end ) {
		m_start = start;
		m_end = end;
	}
}

internal class Calendar {
	
}

{% endhighlight %}

TODO: Think up some tests for this code
// Something with multiple layers
if( condition 1 ) {
	return
}

action
if( condition 2 ) {
	return result
}

// TODO: Find out where that TDD lesson was that you found including the helper methods/refactoring

1. Considers data driven tests when behaviour overlaps and changes can be modelled as input/output data
2. If there is logic that is critical to the test, leave it in the test. The converse is also reasonable. If it is not important to the test give it a name that indicates that is so.
3. Reduce the amount of mocking you are doing. Setting up and using mocks clutters up tests.
4. Do you need batches of assertions? Perhaps only asserting critical aspects of tests and having more tests. If you still feel like asserting many things have you considered BDD?

You should be able to see all three parts clearly in the tests.
Pull redundancy into the methods, but try to keep as much as you can in the tests.

Keep what you are testing in the tests themself and not in helper methods.
Keep it as simple as possible
Do not duplicate the code.
Duplicate tests? Do cases make sense? Risk => inputs/outputs start to be harder to follow.
Choose what you want to do with mocks (I started with mocking then moved to reusable fakes.)

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[c2-aaa]: http://c2.com/cgi/wiki?ArrangeActAssert
[fundamentals]: http://defragdev.com/blog/?p=783
[mocks-smell]: http://devblog.avdi.org/2011/09/06/making-a-mockery-of-tdd/
