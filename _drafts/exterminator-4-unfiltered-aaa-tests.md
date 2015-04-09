---
layout: post
title:  "Exterminators Week 4 - Unfiltered AAA"
date:   2015-03-30 00:09:07
tags: goals improvement career focus quality exterminator
---

The gold standard unit tests for testing is Arrange, Act and Assert or AAA. As
an [Exterminator][tribute], I have been spending lots of time lately reading
and writing unit tests. Keeping duplication to a minimum without obscuring what
is being tested behind layers of indirection is important.

I want to write clear and easy to understand tests. Looking at the tests it
should be clear what each case is validating without needing to read the entire
file. If a test fails any other developer should be able to figure out what is
being tested by reading the test name and body.

This starts to break down for troublesome classes that were [never design for testing][legacy]
in the first place. Maybe the setup is very complicated or many tests have
similar assertions. Add in mocking to tease apart dangerous dependencies and
you have a recipe for fun. As the tests grow it becomes important to reduce
the duplication without sacrificing clarity.

One extreme to maintain being able to glance at a test and know exactly what is
doing would be to put all of the setup and logic required in the test itself.
Down this road is madness and a monstrous unmaintainable mess. Many tests would
be nearly identical and simple changes could easily break many tests as once.

Another extreme would be place all the setup or assertions into separate
methods. While this cuts down on the duplication it becomes harder to see what
each test is doing. Exactly what is happening becomes hidden behind the helper
methods. I think there are approaches here that can work better and still
reveal what the tests are validating. It is important to strike a balance so
the tests have less duplication, but what is being tested is still readily
apparent.

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