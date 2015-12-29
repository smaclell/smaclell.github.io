---
layout: post
title:  "Everything You Need For Professional PowerShell Projects"
description: ""
date:   2015-12-31 23:55:07
tags: powershell
image:
  feature: https://farm3.staticflickr.com/2866/10518792105_da339440a7_b.jpg
  credit: ":the handshake : midtown, manhattan, new york city (2013) by torbakhopper - CC BY-ND 2.0"
  creditlink: https://www.flickr.com/photos/gazeronly/10518792105/
---

We write alot of PowerShell. We didn't realize it when we started, but our
projects have gotten much bigger. What seemed like a small bit of glue is now
the core project. As the projects grew we learnt some lessons in how to keep
them maintainable.

TODO: Clarify the title. Stronger intro/outro. Every project should have these basics.

**Layout your project clearly.** At first we tossed our files in one big
directory and a bunch of messy dot included files. This was brutal. Finding
anything was impossible.

Now we have all entry scripts at the root of the project, all modules in a
``lib`` folder and ``tests`` on their own. More folders are added as needed.
A consistent layout for files makes it easy to find your way around.

**Test thoroughly.** We were naive when we first started our project. What the
project did was really simple. As a result, we thought all we needed to do was
run the code through the happy path. As the code grew this was no longer enough.

We now diligently test each module independently then again with more
comprehensive tests together. We absolutely love [Pester][pester]. Pester is
an amazing testing library for PowerShell. If you have not used it, go check
it out now.

With Pester we have greatly improved our unit testing. Our previous testing
only validated large scenarios where it was really hard to test edge cases.
We could now test individual functions in isolation to expose more permutations
caused the lower levels.

**Modules for everything.** We started with magical ``library.ps1`` scripts which
would be included in every other script. Everything was written as a script to
either be dot included or directly called. This was great when we started, but
as we grew the project started to fall down.

With a newer project we started by placing everything into small modules. Each
module has a single responsibility to give it a purpose, i.e. setting up one
part of our application. Many of the module are small given their limited
responsibility.

Within each module we intentionally keep some functions private. This allows us
to shrink the surface area of each module without losing functionality. With
our included script files before this would not have been possible.

**Continuous integration is mandatory.** From the beginning our projects
have had the ability to check them out, run all tests and publish releases.
This allowed us to rapidly add functionality while keeping up our hygiene. The
code remains clean and we can make sure it meets our basic requirements.

As we continued to improve, most of our projects have added [Preflights][preflights].
This complemented our existing continuous integration. The added benefit has been
keeping problems from ever reaching our master branch.

Our added emphasis in testing at various levels in the project improved our
confidence. Every build/test run would cover even more of the application and
edge cases.

Summary
===============================================================================

We have learnt alot from maintaining PowerShell projects for the past few years.
Our new projects are rock-solid. We try to include the following in every project:

* Consistent Layout
* Thorough Testing
* Single Responsibility Modules
* Continuous Integration

[pester]: https://github.com/pester/Pester
[preflights]: {% post_url 2015-09-29-preflights-changed-our-world %}
