---
layout: post
title:  "Testing at the API Boundary"
date:   2015-02-28 23:11:07
tags: testing services api
---

Building services with strong versioned API's provides a great place to test
applications without the churn. This level is well suited to integration and
unit tests. Test along API boundaries to more easily prevent regressions and
validate functionality than if testing directly against the API.

I have been thinking more about building applications with the API first. This
promotes decoupling and modularity from the start, but also is an excellent
place to test the application. This is definitely an area I am not an
expert and have a great deal to learn.

With the project we were working on, we tried to break up our dependencies
across smaller libraries, tools and services. Services declared their own APIs
in a versioned manner using from backwards compatible data/responses and
sometimes explicit versions within the urls.

Why
===============================================================================

Here is why I think you should focus on testing the API.

1. *Less churn*

Intentionally versionning along an API provides more stability compared to
other code. Smaller classes and UI elements are more likely to change which
would impact any associated tests. Tests against service endpoints are not
affected by implementation details directly.

Backwards compatibility across versionned contracts will ensure that any tests
targeting the API continue to server their intended purpose as the contract is
maintained. When new APIs are made available completely new tests can be added
without changing existing tests. When APIs are retired their test suites can be
removed with them.

With less churn testing the service is easier to maintain.

2. *Documentation*

Testing at the API boundary serves as additional documentation. By reviewing
the tests newer developers unfamiliar with the system can understand how it
works and what operations are available.

This documentation can be further enhanced with executable specifications, such
as [cucumber][cukes]. By writing detailed specifications for the service
against the API directly the desired behaviour is validated to work as
intended.

3. *Preventing regressions*

Tests that reinforce the public service's API protect against regressions. They
can easily confirm that a release is ready and prevent issues for the entire
lifespan of the service. Other test coverage is useful, but does not provide
the same guarantees the service works as intended end to end.

Necessary, but not sufficient
===============================================================================

I think for small services tests against the API may be enough. We have some
services with very comprehensive API tests and few unit tests. The tests take
longer to run compared to pure unit tests, but we are very confident about
integrating with the service due to these higher level tests. This is even
easier with this particular with this service since it is highly integrated
with other services and very simple use cases.

Other services have benefit from a higher percentage of unit tests. Unit tests
are better suited to covering everything beneath the service API. Each class
may introduce permutations and new behaviour hidden from the API that would be
impossible to test from the outside. Our services look like ice bergs with most
of the code beneath the surface. Everything above the water needs to behave as
expected and all the dangers below the water must be closely watched.

I think thoroughly testing the API is necessary to reinforce the health of any
service, but not sufficient to prevent all defects.

[microservices]: http://martinfowler.com/articles/microservices.html
[hal]: http://stateless.co/hal_specification.html
[cukes]: https://cukes.info/
