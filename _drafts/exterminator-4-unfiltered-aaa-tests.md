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

Your Turn
===============================================================================

Unit testing can be great fun, prevent defects and grow your design. Using the
AAA pattern effective will lead to better tests. Even though legacy code can
make testing much harder I think it is well worth it.

I challenge you to write all of you tests using the AAA pattern. I think you
will how much easier to understand your tests become.

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[c2-aaa]: http://c2.com/cgi/wiki?ArrangeActAssert
[fundamentals]: http://defragdev.com/blog/?p=783
[mocks-smell]: http://devblog.avdi.org/2011/09/06/making-a-mockery-of-tdd/
[things]: {% post_url 2015-02-11-4-things-your-tests-are-telling-you %}#recovering-mockist
[classical]: http://martinfowler.com/articles/mocksArentStubs.html
[fake-it]: http://www.jeffdutradeveloper.com/2014/08/25/fake-it-till-you-make-it-and-try-not-to-mock-others/
