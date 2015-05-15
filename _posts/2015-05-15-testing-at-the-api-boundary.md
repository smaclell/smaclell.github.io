---
layout: post
title:  "Testing at the API Boundary"
date:   2015-05-15 01:05:07
tags: testing services api
image:
  feature: wall-edge.jpg
---

Building services with strong versioned API's provides a great place to test
applications without the churn. Testing along API boundaries can more easily
prevent regressions and validate functionality.

I have been thinking about building applications with the API first. I don't
have lots of experience here, but want to learn more since it seems to be the
direction technology is trending with decoupled architectures and
[microservices][microservices].

API first promotes decoupling and modularity from the start. Beginning your
early development by also testing thoroughly at the API is a great way to build
quality in.

With our projects we tried to break up our dependencies across smaller
libraries, tools and services. The service API's are versionned using part
of the url and/or backwards compatible data/responses. We have added tests for
these APIs which have been useful while maintaining the services.

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
targeting the API continue to be perform their intended purpose as long as the contract is
maintained. When new APIs are made available completely new tests can be added
without changing existing tests. When APIs are retired their test suites can be
removed at the same time.

**Tests provide additional documentation and use case examples.** By reviewing
the tests developers unfamiliar with the system can understand how it
works and what operations are available. Edge cases that are important to
preserve can be highlighted by the tests.

This documentation can become executable specifications, such
as [cucumber][cukes]. By writing detailed specifications for the service
API the desired behaviour it can clarified and what is validated. Using
scenarios to describe what being tested can allow less technical team
members to review the tests and understand what is being covered. This is not
something I have tried in depth, but would like to in the future.

**Preventing regressions in public API.** API tests can easily confirm if a
release is not ready to ship and prevent issues for the entire lifespan of the service.
Other test coverage is useful, but does not provide the same guarantees the
service works as intended end to end.

Testing can call APIs the same way a normal client would, allowing the tests to
exactly replicate use-cases. UI tests can only indirectly validate functionality
and unit tests only cover isolated scope.

Start Here, Go Deeper
===============================================================================

I think for small services testing only against the API may be enough. We have some
services with very comprehensive API tests and few unit tests. The tests take
longer to run compared to pure unit tests, but we are very confident about
integrating with the service due to the higher level tests. Primarily testing
along APIs is even better for this services because it has simple use cases and
heavily integrates with other services.

Other services have benefit from a higher percentage of unit tests. Unit tests
are better suited to covering everything beneath the service API. Each class
may introduce permutations and new behaviour hidden from the API that would be
much harder to test from the outside. Our services look like ice bergs with most
of the code beneath the surface. Everything above the water needs to behave as
expected and all the dangers below the water must be closely watched. I feel the
majority of services would fall into this category and would benefit from
a wider range of testing above and beyond the versionned API.

I think thoroughly testing along versionned API's is necessary to protect the
health of any service and a great starting point for testing. Reduced
churn, improved documentation and preventing regressions are all great reasons
to invest heavily in comprehensive API testing. How would your development look
different with more API testing?

[microservices]: http://martinfowler.com/articles/microservices.html
[cukes]: https://cukes.info/
