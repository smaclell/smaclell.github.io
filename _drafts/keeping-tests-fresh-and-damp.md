---
layout: post
title:  "Keeping Tests Fresh and DAMP"
date:   2015-04-15 00:09:07
tags: unit-testing testing exterminator
---

This is a dump of thoughts. If you want to make it a post clean them up.


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


Do you simplify it? Go for just DAMP vs Dry?

What are some things we can do about it?

**1. Mute the unnecessary**

Refactor or remove repeated setup not essential to the tests. An objects where
any possible value would be valid for the test as long as it is consistent. If
possible I try to move these objects out of the test completely or use factory
methods to create them.

TODO: Think of a better example - setting up a mock, date or some other case
you don't care about.

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

**2. Relax and Focus**

**3. Reduce your mocks**

In my journey to use fewer and fewer mocks throughout my tests I am finding my
test setup is often much simpler. As I said in my [previous post][things] I am trying to
do more [classical TDD][classical]. Where I would normally use a complicated mock
object I am now favouring using the real thing or simple fakes.

Recently I faked a series of small interfaces used throughout many tests. This
allowed me to use the same fakes many places throughout the test suite and
vastly simplified the setup. Before using the fakes I had a series of
interrelated mocks that were had to follow and difficult to configure.

Switching to the fakes allowed me to perform the same activities as the mocks
without all the additional setup. Another benefit was that my fake
implementation was much closer to the real implementation and a whole lot less
artificial.

Even better has been using concrete classes from the implementation. Although
my tests have become more interrelated knowing the actual classes work together
correctly is worth the it. This has allowed me to remove layering throughout
my code only used to insert mocks testing.

Try the real thing. If you can't do that, [Fake It Till You Make It][fake-it].

**4. Data Driven Tests**

Duplicate behaviour throughout a series of overlapping tests can be
consolidated using data driven tests. I have been using this a lot lately and
really enjoying it. If the setup can be extracted to common variables and the
inputs map cleanly to expected output then using data driven tests works well.

{% highlight csharp %}
using System;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;

namespace Example {

	[TestFixture]
	internal class StringCalculatorTests {

		private static IEnumerable<TestCaseData> AddCases() {
			yield return new TestCaseData( null, 0 );
			yield return new TestCaseData( "", 0 );
			yield return new TestCaseData( "1", 1 );
			yield return new TestCaseData( "1,2", 3 );
			yield return new TestCaseData( "1,2,3", 6 );
		}

		[Test]
		[TestCaseSource( "AddCases" )]
		public void Add_WithValidInput_ReturnsExpectedOutput(
			string input,
			int expectedResult
		) {
			StringCalculator calculator = new StringCalculator();

			int result = calculator.Add( input );

			Assert.AreEqual( expectedResult, result );
		}

	}

	internal class StringCalculator {
		public int Add( string input ) {
			return (input ?? "")
				.Split( ',' )
				.Where( s => !string.IsNullOrEmpty( s ) )
				.Select( int.Parse )
				.Sum();
		}
	}
}
{% endhighlight %}

While this technique does help showcase the behaviour of the tests better, it
can become harder to follow if there is more complicated setup. I will let you
be the judge as to when this technique is no longer working. I have been using
it alot lately to great effectiveness and have only had a few cases where it
felt like overkill. In these cases I was trying to get too fancy with the setup
and needed to simplify it.

using System;
using NUnit.Framework;

[TestFixture]
internal class CalendarTests : {

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