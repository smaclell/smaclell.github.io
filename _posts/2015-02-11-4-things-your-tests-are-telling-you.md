---
layout: post
title:  "4 Things Your Tests Are Telling You"
date:   2015-02-11 21:15:00
tags: testing feedback
image:
  feature: NERVAControlRoom-feature.jpg
  credit: Wikimedia Commons
  creditlink: http://commons.wikimedia.org/wiki/File:NERVAControlRoom.jpg
---

Your tests can tell you many things about your application. Looking into your test
results can provide ways to clean up your code or uncover hidden defects.
High quality unit and integration tests are the cornerstone of any well-functioning
Deployment Pipeline or Continuous Integration. Keeping this important part of
your application's development healthy is critical; this includes listening to the feedback the tests
are giving you.

There are 4 quick and dirty types of unhealthy tests giving you feedback:

1. Ignored Tests
2. Slow Tests
3. Intermittently Failing Tests
4. Failing Tests

### Ignored Tests

Being ignored is where tests go to die. Few teams have the discipline required
to re-evaluate and re-enable ignored tests. The big question is why the
tests are being ignored. I don't think there are any legitimate reasons to completely ignore a
test long-term. If it is a good test and it passes, why is it not turned on?

Some reasons why tests start being ignored include unexpected breaking changes, or tests
start to fail. Developers
may use ignored tests to avoid dealing with a problem immediately. This is the easy
way out, but it is hiding the actual problem. A decision about whether the test
should be fixed or removed permanently needs to be made, instead of hiding
the test by ignoring it. This might be covering a very real problem caused by
the change and understanding the root cause is important.

Tests that are configured to only run when explicitly requested are similar, but
in my opinion are more acceptable for short periods of time. They represent a conscious
choice to run the test only in specific circumstances. These tests
could become completely broken before you try to run them again. As a result, it is
important to make sure they are exercised at least once per release to make sure
they continue to work as expected. Ideally, tests would only be marked explicit
for a short period of time, or would be updated to run later during the
Deployment Pipeline.

The risk is that ignored or explicit tests that are not run for long periods of time 
can easily fall into disrepair. Running tests frequently helps to reduce the number 
of changes between the last time the tests passed. If the tests are run on every
commit, you can immediately identify the code that broke the tests.
Explicit or ignored tests that have not been run for a long time have no
guarantee that they still test what they were originally intended to, or that
they will pass.

### Slow Tests

For easy places to speed up your Deployment Pipeline, look no further than slow
tests. According to [the book on Continuous Delivery][cd] the ideal goal for
initial testing is 10 minutes. Too many lengthy integration tests can bog down your
Deployment Pipeline and prevent it from being a viable feedback mechanism. The
longer your tests take to run, the less likely Developers are to run them on a
regular basis; they might even begin working around them. Your tests may be slow if they are doing
too many things, have bad dependencies, are attempting to test parallelism by sleeping, etc.

Straightforward solutions to speed up your tests include pushing the long
tests down a layer, running them in parallel, or running the tests later in the
Deployment Pipeline.

Converting a slow integration test into a series of unit tests or mocking out
the slowest portion can massively improve the performance of your tests. We
recently did this to one of our services by mocking out external service
dependencies and testing the remainder
of the system end-to-end. This allowed us to add even more tests with better coverage
than the original and make the new tests over 100 times faster.

On another project we started running tests that would
take hours to run in parallel. Using additional hardware, the team set up isolated test runs
which ran part of the test suite. The overall duration could then be reduced
almost linearly with each isolated test run, i.e. 2 runners ~2 times as fast.
Some tests could be run in parallel without extra changes or extra set-up. This
was first implemented by categorizing the tests as "Parallel Safe" and then
assuming all other tests needed to be sequential. The parallel tests were much
faster, but maintaining test categories can be tedious and error-prone if not managed effectively.

Staggering tests to run the most business-critical validation early and often can
improve the feedback cycle. As tests become more comprehensive or require more
integration between components, they will naturally take longer. A first step is
to categorize tests so the most important and relatively fast tests are
run early, and all other tests can run in later validation stages. Depending on
your application this might be a blend of unit/integration tests run every time
new code is committed, as
recommended by the [Continuous Delivery Book][cd]. Longer-running tests like
performance validation or UI tests can then be run separately. This split
ensures the later tests can focus on their intended goal and rely on the
earlier assertions. Bad builds that do not pass the early tests do not need to
run the more comprehensive tests, saving time and money.

### Intermittently Failing Tests

Trust is an important aspect of teams and test suites. Tests that fail often,
or do not pass reliably, reduce trust and confidence in their results.
Tests failing intermittently are highlighting opportunities to improve and
regain trust.

The reliability of external components is critical to our applications. When
services we consume on a regular basis begin to break our tests, it demonstrates
areas were we could make our application more resilient. If the system breaks
while running tests, it can break for the same reasons in production. Using
[circuit breakers][breaker] or retries for intermittent failures can
accommodate issues with upstream services. More failure or resiliency testing
might be needed to ensure edge cases not yet encountered are covered. Some companies like
PagerDuty have included this type of testing into their normal work flow with
activities like [Failure Friday][failure]. These extra tests are not difficult
to perform and ensure that your application is robust and failure-tolerant.
The alternative is flying by the seat of your pants during an outage, hoping
everything works as planned.

Frequently failing tests caused by team member commits is a great opportunity
to dig deeper. Infrequent breaks caused accidentally are not a big deal,
but when it becomes a weekly or daily occurrence it can start to hold up the
whole team. It can be easy to blame the individual for their actions, but it is
important to take
the time to help them understand how to avoid these issues and learn from what
happened. Perhaps they were having a bad day or did not know about the available build
and tests. If they have not seen the tests in action,
build/test breaks are a great learning opportunity.

Another category is easily broken tests. When these tests fail
from the slightest change, it can be from brittle tests or overly complicated
code. Mocking in tests can begin to introduce fragile tests that mirror the
functionality being tested too closely.
These restrictive tests do not provide enough flexibility for other
implementations by the class(es) being tested.

Last year we had an interesting discussion about unit testing and apparent
[harm caused by TDD][harm]. At the time I was using too many mocks in my tests,
which affected the design quite a bit. Martin Fowler has a great article
contrasting TDD done [classically and with mocking][mockist]. I am a recovering
mockist. We talked about this in-depth and came to the conclusion that TDD and
unit testing were not the issue, but instead TDD with bad mocking was the
culprit. Heavy mock usage throughout the unit tests resulted in more
coupling between the code and tests, which ultimately leads to worse tests. You
could even call [mocks a code smell][mocks-smell] or recommend [avoiding mocks][avoiding-mocks]
to improve test isolation.

Rather than dogmatically covering everything with unit tests, we began to
strengthen our integration tests. For systems whose sole purpose was to act
as an integration, we did not implement any unit tests, or removed them if they
frequently failed due to fragile mocks. Deleting the tests was better than
needing to rewrite them with every minor code change to the integrated
components. Our applications we maintain now have a healthy mix of unit and
integration tests, which helps us remain confident as we make changes throughout
the system. In many ways this resulted in better test coverage for the most
important aspects of our systems and less effort to maintain the tests.

### Failing Tests

Some unlucky applications have the final form on bad tests; tests that always
fail. I hope it never happens to you. I am sure there are many rational ways
teams get into this state and begin to accept it as a reality. These tests
represent something far more sinister; your feedback loop is fully broken. Having a
single test that is always broken opens the door for more tests to also be left
in the same state of disrepair. Looking at the test results is no longer a
binary true/false on whether the code is healthy. The message here is clear:
something must be done.

Broken tests are work left undone. I believe it is important to not leave
your tests in this state. You should not ship your application if you have
permanently broken tests. Without digging deeper, you cannot tell if the new
code changes have broken something. You are ignoring broken tests at your own
peril. Choose between fixing the tests and removing them. If the test is
valuable but needs some work, take the time to do it right. However, if you
don't think it is worth it, delete the test and move on. Ignored or failing
tests don't improve your test coverage at all and provide only an artificial
sense of safety. It is more important to be able to trust your tests than to
have thousands of tests that are always broken.

When Continuous Integration is working well it stays green. The entire team
supports keeping the build passing, and anything that goes wrong is fixed
immediately or reverted. If the code does not compile, it is fixed right away.
If a test breaks, it is fixed right away. Developers can trust everything
works as expected and problems are addressed quickly. Permanently failing tests
break the normal work flow and do not belong in Continuous Integration.

Who is accountable for fixing tests when they break? For our team
it is the developer who committed the code. If finding who is responsible is
not clear, no one involved will feel accountable for getting the tests back
to normal. It might be that the team does not feel empowered to spend time on
improving the code or fixing the tests. This is a short-sighted strategy which
will ultimately result in hard to maintain code base where every change feels
impossible. You can break this cycle and take the solution into your own hands
by holding yourself accountable and doing whatever it takes to fix the tests.

Conclusion
===============================================================================

There are many things you can learn from your tests beyond whether they pass or
fail. If your code is encountering ignored, slow, intermittently
failing or always failing tests, your tests are telling you something.

At the end of the day your tests are a tool for keeping your application
healthy. Clean tests that validate the right things provide invaluable feedback for
your application. As your code changes and grows, keeping the tests healthy aids in
keeping your application functioning as expected. Learning from your tests and
improving your application will lead to ways for improving both.

What are your tests telling you?

<hr/>

*I would like to thank my lovely wife [Angela][ange] for graciously grammarifying this
post. The extra commas and sentences that make sense were her doing.*

[cd]: http://www.amazon.com/Continuous-Delivery-Deployment-Automation-Addison-Wesley-ebook/dp/B003YMNVC0/
[breaker]: http://techblog.netflix.com/2011/12/making-netflix-api-more-resilient.html
[failure]: http://www.pagerduty.com/blog/failure-friday-at-pagerduty/
[harm]: http://david.heinemeierhansson.com/2014/test-induced-design-damage.html
[mockist]: http://martinfowler.com/articles/mocksArentStubs.html
[avoiding-mocks]: https://www.destroyallsoftware.com/blog/2014/test-isolation-is-about-avoiding-mocks
[mocks-smell]: http://devblog.avdi.org/2011/09/06/making-a-mockery-of-tdd/
[ange]: http://macangela.tumblr.com
