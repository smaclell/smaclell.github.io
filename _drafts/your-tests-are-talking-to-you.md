---
layout: post
title:  "Your Tests Are Talking To You"
date:   2014-09-22 23:11:07
tags: testing feedback
---

Your tests can tell you many things about your system. Looking into your test
results can provide ways to clean up your code or uncover hidden defects.
Quality unit and integration tests are the corner stone to any well functioning
Deployment Pipeline or Continuous Integration. Keeping this important part of
your application's healthy is critical by listening to the feedback the tests
are giving you.

There are 4 quick and dirty pieces of feedback unhealthy tests can give you:

1. Ignored Tests
2. Slow Tests
3. Intermittently Failing Tests
4. Failing Tests (TODO Combine with Ignored)

Ignored tests is where tests go to die. Few teams have the discipline required
to return and re-enable ignored tests. The big question to ask is why is the
test ignored. I think there are no legitimate reasons to completely ignore a
test long term. If it is a good test and passes then why is it not turned on?

Often ignore tests happen when there are breaking changes to a system or they
start to fail or one of the other reasons tests are taking to you. Developers
use ignored tests to not deal with a problem immediately that could be left for
later. This is the easy way out but is hiding the actual problem. Instead of
sweeping the problem under the rug make the decision whether the test should be
fixed or removed permanently.

For easy places to speed up your Deployment Pipeline look no further than slow
tests. Accordingly to [the book on Continuous Delivery][cd] the ideal goal for
initial testing is 10 minutes. Too many integration tests can bog down your
Deployment Pipeline and prevent it from being a rapid feedback mechanism. The
longer your tests take to run the less likely Developers are to run them on a
regular basis or might even begin working around them. Slow tests may be doing
too many things, attempting to tests parallelism by sleeping or has too much
setup.

Straight forward solutions include pushing the tests down a layer, running them
in parallel or running them later in the Deployment Pipeline.

Converting a slow integration test into a series of unit tests or mocking out
the slowest portion can massively improve the performance of your tests. We
recently did this by mocking out service dependencies and testing the remainder
of the system end to end. Not only were there more tests with better coverage
they were over 100 times faster to perform the same validation.

On another project we started running tests in parallel that original would
take hours. With additional hardware we setup isolate test runs that ran part
of the whole test suite. With this change we managed to reduce the duration
linearly with each separate test run, i.e. 2 runners ~2 times as fast. For
more tests we were able to run them without additional setup and had moderate
success. The tests were much faster but now the tests are more brittle and need
to be managed to ensure we know which tests can execute in parallel or
sequentially.

Staggering tests to run the most business critical tests early and often can
improve the feedback cycle. As tests become more comprehensive or require more
integration between components they will naturally take longer. Categorize
tests so that the most important and relatively fast tests run early and all
other tests can run in later validation steps helps provide the most essential
feedback earlier. Depending on your application this might be a blend of
integration/acceptance tests run every time your commit new code, as
recommended by the [Continuous Delivery Book][cd]. Performance tests and other
intensive validation only makes sense to validate after basic functionality is
verified.

Trust is an important aspect teams and test suites alike. Tests that fail often
or do not pass reliably reduce trust and confidence that the tests are useful.
Depending on the source of the failure there are different opportunities to
improve that are being highlighted. Due to the applications we work on the
reliability of external components is critical to our applications. When
services we consume on a regular basis begin to break our tests it demonstrates
areas were we could make our application more resilient.

If the test is valuable but needs some work take the time to do it right.
However, if you don't think it is worth it then delete the test and move on.
Your coverage does not change and your tests become more reflective of what
they are doing.

Brittle tests are bad. Good tests give clear and consistent feedback confirming
your application behaves the way you expect. Tests that routinely fail are
always suspect. Intermittently failing tests tend to erode any confidence in
the entire test suite.

Tests that frequently fail due to code changes are
a great way to highlight areas that probably have more bugs. Easy to break with
new code means the existing code is fragile or over complicated.

Intermittently Failing tests, brittle is bad. You are not getting your moneys worth
Ignored tests, warning flag that means the test should be deleted or reenabled. Probably hiding a defect or change in requirements

Complicated setup, your code is too complicated => probably over mocking

[cd]: http://www.amazon.com/Continuous-Delivery-Deployment-Automation-Addison-Wesley-ebook/dp/B003YMNVC0/