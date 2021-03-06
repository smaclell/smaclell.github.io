---
layout: post
title:  "Libraries over Frameworks"
date:   2015-03-13 00:19:07
tags: development design daryl
---

Favour using and creating libraries over frameworks.

Over the past several months I have been trying to learn more from Daryl. He
helped us track down the insidious [PowerShell problem][ps] and is a phenomenal
member of our team. I have learnt a great deal from him and feel the least I
can do is write down what I have to learned and share it with you.

The project we are on has led to us to build many small applications. Since
the problems we are solving are widely applicable to others at the company we
have tried to make our solutions reusable. To achieve this goal, Daryl has been
adamant that we write our components as modular libraries instead of custom
frameworks.

This advice seemed counter intuitive at first, but the more we applied it
the more I agreed with him.

The Past and The Present
===============================================================================

For a long time Daryl was part of the team responsible for providing a unified framework
for our core application. This framework provided the base functionality for
almost everything. Likewise, I had written several internal tools as opinionated
frameworks which would make building/deploying our application easier. You could
unbox the build framework, plug in your settings and begin development with very
little friction. Extension points were exposed to allow the frameworks to be
extended or enhanced.

Today when we add new functionality, we have been trying to create small
reusable pieces. Each addition is written as a library to be consumed as
needed. Each library is focused on solving one concrete need; a single responsibility
embodied in a library. These new libraries have been adopted throughout the
organization. We have been able to extend and replace them as new challenges
arrive. They are downloaded, integrated and used where they are considered
useful.

Making the Choice
===============================================================================

In both cases developers could be productive using or implementing either
libraries or frameworks, but the solutions would be completely different.
Your application fits within a framework whereas your application decides
where a library would fit best.

<figure>
	<img
		title="Where do you want to do you work? On the inside of the framework or outside of a library."
		alt="Two black and white squares with another square in the center of each of the opposite colour"
		src="{{ site.url }}/images/LibraryOverFramework.png" />
</figure>

Aside from very narrow frameworks, most frameworks tend to
have wide implications on the applications they are used in. I have been really
enjoying [Nancy][nancy], a lightweight MVC web framework for .NET.
Despite [Nancy][nancy]'s goal of simplicity, it constrains how your application is
structured around it. Contrast this with the library [Dapper][dapper], a simple
object relational mapper for .NET, that has little impact to your overall
application and lets you focus on the problem you are trying to solve.

The goal should be to solve a problem and not to use some piece of software.
Using small interchangeable libraries lets you, the developer, choose the best
tool for the job, whereas frameworks can restrict what choices you can make. As the
application grew our framework became a barrier. It tried to do everything for
everyone, but ended up limiting what could be done to only what was supported
by the framework. All enhancements needed to occur in the frameworks which
slowed down solving the actual problems.

When a library no longer solves the problem it was intended to solve, you can either
updated it or replace it. This is not possible with a framework since your core
application may be intertwined with framework specific dependencies or idioms.
Like a two edge sword these dependencies constrain updates to both derived
applications and the framework alike. Favouring light weight libraries reduces
the dependencies on external tools which better isolates your application from
future changes to the library and vice versa.

There comes a point where a simple library does not do enough or the domain
is large enough that you need something more comprehensive. We use the .NET
framework and web various frameworks for basic functionality and plumbing. This is where I
think light-weight frameworks like [Nancy][nancy] really shine. They still do one thing
really well, but what they do happens to be much larger. The way they do it can be
less opaque and can allow you to change the parts which don't work the way you need,
i.e. changing Nancy's JSON serialization conventions.

Wrapping Up
===============================================================================

We will continue to favour using and creating libraries over frameworks. On our
latest project we have found focusing on small purpose driven libraries
has been very useful and avoided issues we have had with large frameworks. The
flexibility and choice over how best to solve problems has helped us to be
more productive. When approaching larger problems where a framework is
appropriate, try to use one which is light-weight.

<hr />

*I would like to thank Daryl again for explaining the why behind his
recommendations. We tried to find out where Daryl first heard about this idea
but did not find it. In the process of searching we did find this great [article][other]
which also highlights why you want to favour libraries over frameworks*

[ps]: {% post_url 2015-03-04-lessons-learnt-while-finding-the-root-cause %}
[nancy]: http://nancyfx.org/
[dapper]: https://github.com/StackExchange/dapper-dot-net
[other]: http://tom.lokhorst.eu/2010/09/why-libraries-are-better-than-frameworks
