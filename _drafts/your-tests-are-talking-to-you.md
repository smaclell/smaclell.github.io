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
4. Failing Tests

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

Frequently failing tests caused by team member commits is a great opportunity
for a conversation. Infrequent breaks caused accidentally are not a big deal
but when it becomes a weekly or daily occurrence it can start to hold up the
whole team. It can be easy to blame the individual for their actions and I
think it is important to keep people accountable, but it is important to take
the time to help them understand how to avoid these issues and learn from what
happened. Perhaps they were having a bad day or did not know about the build
and tests that were available. If they have not seen the tests in action then
using any failures as a teaching/learning opportunity to make the system
better.

Tests that are easily broken fall into another category. When these tests fail
from the slightest change it can either be brittle tests or overly complicated
code. Mocking in tests can cause tests to become extremely easy to break since
they often mirror the functionality in the method being tested too tightly.
These restrictive tests do not provide enough flexibility for other potential
solutions to the responsibilities performed by the classes being tested.

Last year there was an interesting discussion around unit testing and apparent
[harm caused by TDD][harm]. At he time I was using too many mocks in my tests
which affected the design quite a bit. Martin Fowler has a great article
contrasting TDD done [classically or with mocking][mockist]. I am a recovering
mockist. We talked about this in depth and came to the conclusion that TDD and
unit testing were not the issue but instead bad mocking was the reason. You
could even call [mocks a code smell][mocks-smell] or recommend [avoiding mocks][avoiding-mocks]
to improve test isolation.

Rather than dogmatically covering everything with unit tests we began to
strength our integration tests. For systems whose sole purpose was to integrate
two other systems we did not implement unit tests or removed them if they
frequently failed due to fragile mocks. Deleting the tests was better than
needing to rewrite them with every minor code changes with the integrated
components. Our applications we maintain now have a healthy mix of unit and
integration tests which helps us remain confident as we make changes throughout
the system. In many ways this resulted in better test coverage for the most
important aspects of our systems.

Some unlucky applications have the final form on bad tests; tests that always
fail. It happens and I hope not to you. I am sure there are many rational ways
that teams get into this state and begin to accept it as a reality. These tests
represent something far more sinister; your feedback loop is broken. Having a
single test that is always broken opens the door for more tests to also be left
in the same state of disrepair. Looking at the test results is no longer a
binary true/false on whether the code is healthy. The message here is clear
that something must be done.

When Continuous Integration is working well it stays green. The entire team
supports keeping the build stable and anything that goes wrong is fixed
immediately or reverted. If the code does not compile, it is fixed right away.
If a test breaks, it is fixed right away. Developers can trust that everything
works as expected and that problems are addressed quickly. Tests that fail do
not belong here.

Broken tests are work left undone. I believe that it is important to now leave
your tests in this state. If the results are showing an issue with the new code
then you probably should not ship your software until the problem is fixed and
the tests pass. You are ignoring this feedback at your own peril. Choose
between fixing the test and removing it. If the test is valuable but needs some
work take the time to do it right. However, if you don't think it is worth it
then delete the test and move on. Ignored or failing tests don't improve your
test coverage at all and provide only an artificial sense of safety.

[cd]: http://www.amazon.com/Continuous-Delivery-Deployment-Automation-Addison-Wesley-ebook/dp/B003YMNVC0/
[harm]: http://david.heinemeierhansson.com/2014/test-induced-design-damage.html
[mockist]: http://martinfowler.com/articles/mocksArentStubs.html
[avoiding-mocks]: https://www.destroyallsoftware.com/blog/2014/test-isolation-is-about-avoiding-mocks
[mocks-smell]: http://devblog.avdi.org/2011/09/06/making-a-mockery-of-tdd/
