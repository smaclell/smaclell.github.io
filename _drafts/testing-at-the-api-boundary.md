---
layout: post
title:  "Testing at the API Boundary"
date:   2015-02-28 23:11:07
tags: testing services api
image:
  feature: wall-edge.jpg
---

Building services with strong versioned API's provides a great place to test
applications without the churn. Testing along API boundaries can more easily
prevent regressions and validate functionality.

I have been thinking more about building applications API first. I don't
have lots of experience here, but want to learn more since it seems to be the
direction technology is trending with more decoupled architectures and
[microservices][microservices].

API first promotes decoupling and modularity from the start. Beginning your
early development by also testing thoroughly at the API is a great way to build
quality in.

With our projects we tried to break up our dependencies across smaller
libraries, tools and services. The service API's are versionned using part
of the url and/or backwards compatible data/responses.

Why API Testing
===============================================================================

I think there are a several reasons why testing along the API is particularly
useful compared to unit and integration tests.

**Less churn and easier to maintain due to versionning.** Versionning along an API provides more stability compared to
other code. Smaller classes and UI elements are more likely to change which
would impact any associated tests. Tests against service endpoints are less
affected by implementation details and should not need to change as often.
Not needing to changes as often results in less churn and easier to maintain
tests.

Backwards compatibility across versionned contracts will ensure that any tests
targeting the API continue to server their intended purpose as long as the contract is
maintained. When new APIs are made available completely new tests can be added
without changing existing tests. When APIs are retired their test suites can be
removed at the same time.

**Tests provide additional documentation and use case examples.** By reviewing
the tests developers unfamiliar with the system can understand how it
works and what operations are available. Edge cases that are important to
preserve can be highlighted by the tests.

This documentation can be further enhanced with executable specifications, such
as [cucumber][cukes]. By writing detailed specifications for the service
API the desired behaviour it can clarified and what is validated.

**Preventing regressions in public API.** They can easily confirm that a
release is ready and prevent issues for the entire lifespan of the service.
Other test coverage is useful, but does not provide the same guarantees the
service works as intended end to end. API tests interact with the target code
the exact same way that any other callers will allowing them to replicate
client use cases exactly. UI tests can only indirectly validate functionality
and unit tests only cover isolated scope.

Necessary, but not sufficient
===============================================================================

I think for small services testing only against the API may be enough. We have some
services with very comprehensive API tests and few unit tests. The tests take
longer to run compared to pure unit tests, but we are very confident about
integrating with the service due to these higher level tests. This is easier
with this service since it is highly integrated with other services and has
very simple use cases.

Other services have benefit from a higher percentage of unit tests. Unit tests
are better suited to covering everything beneath the service API. Each class
may introduce permutations and new behaviour hidden from the API that would be
much harder to test from the outside. Our services look like ice bergs with most
of the code beneath the surface. Everything above the water needs to behave as
expected and all the dangers below the water must be closely watched. I feel the
majority of services would fall into this category and would benefit from
different types of testing, such unit or exploratory testing.

I think thoroughly testing along versionned API's is necessary to protect the
health of any service, but not sufficient to prevent all defects. Reduced
churn, improved documentation and preventing regressions are all great reasons
to invest heavily in comprehensive API testing. How would your development look
different with more API testing?

[microservices]: http://martinfowler.com/articles/microservices.html
[cukes]: https://cukes.info/
