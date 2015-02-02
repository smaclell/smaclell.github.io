---
layout: post
title:  "Libraries over Frameworks"
date:   2015-02-01 23:11:07
tags: development design daryl
image:
  feature: LibraryOverFramework.png
---

Favour using and creating libraries over frameworks.

Over the past several months I have been trying to learn more from Daryl. He
helped us track down the insidious PowerShell problem and is a phenomenal
member of our team. He has taught me many things and I feel the least I can do
is write them down.

The project we are on has lead to us to build many small applications. Since
the problems we are solving are widely applicable to others at the company we
have tried to make them reusable. To achieve this goal, Daryl has been very
adamant that we write our components as modular libraries instead of custom
frameworks.

This advice seemed counter intuitive to me at first but the more we apply it
the more I agree with him.

For a long time our core application was written by a Daryl and a team
responsible for a unifying framework that provided base functionality for many
common activities. Likewise I had written several internal tools as opinionated
frameworks that would make building/deploying our application easier. You could
unbox the framework, plug in settings for your application and then begin
adding anything else you wanted. Extension points are exposed as needed to
allow the frameworks to be extended or used.

Today, when we add new functionality we have been trying to do so by creating
small reusable pieces. Each addition is written as a library to be consumed as
needed elsewhere. They are focused exclusively on solving one concrete need.
These new libraries have been adopted throughout the organization. We have been
able to extend and replace them as needed. They are downloaded, integrated and
used where they are considered useful.

In both cases developers could be extremely productive but their relationship
with the library or framework is completely different. Both cases can strive to
adopt the unix philosophy of "do one thing and do it well" but how they
approach it is completely different. Your application fit withins the framework
whereas your application decides where the library would fit best.

The goal should be to solve a problem and not be to use some piece of software.
Using small interchangeable libraries lets you the developer choose the best
tool for the problem whereas larger frameworks can become restrictive. As the
application grew our framework became a barrier. It tried to do everything for
everyone but ended up being limited. All enhancements then needed to occur
through the frameworks which prevented solving the actual problems.

When a library no longer solves the problem it was intended to you can either
updated it or replace it. This is not possible with a framework since your core
application may be intertwined with framework specific dependencies or idioms.
