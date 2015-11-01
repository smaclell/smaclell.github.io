---
layout: post
title:  "NancyFx's DI Request Container"
date:   2015-09-29 22:37:07
tags: troubleshooting dependency-injection nancyfx viktor chris
---

This week my coworkers, Chris and Viktor, had a fun issue they had a hard time
getting to the root cause. They added some caching to speed up a heavily used
route which led to some unexpected tests breaking. In this post I wanted to dig
into the root cause for why it broke.

Change:

Addressing a performance problem by introducing caching per cache request.

Problem:

Code was fine, oddly broke an integration tests which seemed unrelated.
Test faked big chunks of the application including the area they changed.

Investigation:

They were able to track the problem down to the dependency injection of their
new component, but did not know why. The test was replacing the component they
had updated, but it had stopped working. Show original registration.

After many
hours of debugging and head to desk slamming they managed to fix the issue by 
allowing the registration to be overridden directly. This worked by the did
not understand the root cause behind what was broken.

Going Deeper: Root Cause

They were right the root cause was dependency injection. Their solution worked
bypassing the reason.

The root cause obscured by me for story telling ;) was because they switched
from registering the type at the application level to the request level. The
framework uses 2 di containers, one for the whole application and a child
per request. The caching was done by creating a new object and caching in the
object. We used DI to create the object only once per http request.

Previously,
the type was registered at the application. The test then registered the type
with what it wanted. When the registration moved from the application to the
request it broke.

Having two levels of container is common. The child container is used first
and then if a dependency cannot be found it then tries the application
container.

Reminder

The one major lesson I learnt last year, was it is important to understand
how your code works (TODO: Link). Have fun. Get to the root cause.
