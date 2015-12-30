---
layout: post
title:  "Rock-Solid PowerShell Projects"
description: "How we now treat our PowerShell projects to keep them easy to maintain."
date:   2015-12-31 23:55:07
tags: powershell conventions maintenance
image:
  feature: https://farm8.staticflickr.com/7528/15037595713_077b784de6_b.jpg
  credit: "The artist by Shawn Harquail - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/harquail/15037595713/
---

We write alot of PowerShell. We didn't realize it when we started, but our
projects have gotten much bigger. What seemed like a small bit of glue is now
the core project. As the projects grew we learnt some lessons in how to keep
them maintainable.

Our first release was really simple. It was just enough to meet our project
goals. We didn't think through how the different pieces fit together. Fast
forward 2 years and it the older projects felt very thrown together.

When we started a new project I wanted to make it feel like a professional
project. Instead of the *good enough* we had with the first project, I wanted
everything to fit together just right. I want to apply all the best practices
we have with any other development. Just being glue was not enough.

This list might seem straightforward and mundane. That is okay! I think these
guidelines are
essential for any project worth your time to maintain. With a looser
language like PowerShell these conventions helped give the project even more
structure. Ultimately, they led to better code.

### Consistent Layout

At first we tossed our files in one big
directory and a bunch of messy dot included files. This was brutal. Finding
anything was impossible.

Now we have all entry scripts at the root of the project, all modules in a
``lib`` folder and ``tests`` on their own. More folders are added as needed.
A consistent layout for files makes it easy to find your way around.

We took this even further. We applied the same layout to the projects and
libraries we maintain. New developers (or you after [4 months away][tribute]) can
open any of the projects and start coding right away.

### Test thoroughly

We were naive when we first started our project. What the
project did was really simple. As a result, we thought all we needed to do was
run the code through the happy path. As the code grew this was no longer enough.

We now diligently test each module independently using [Pester][pester] then again with more
comprehensive integration tests together. Pester is
an amazing testing library for PowerShell. We love Pester. If you have not used it, go check
it out now.

Pester has greatly improved our unit testing. Our previous testing
only validated large scenarios and missed the edge cases.
We now test individual functions in isolation to expose more permutations
caused by the lower levels.

### Modules for Everything

Initially, any reusable functions were place in magical ``library.ps1`` scripts, which
would be included in every other script. Everything was written as a script to
either be dot included or directly called. This was great when we started, but
did not scale as the project became more complex.

With newer projects we place everything into independent modules. Each
module has a single responsibility, i.e. setting up
part of our application. This keeps every module small and focused.

Within each module we intentionally keep some functions private. This allows us
to shrink the module's surface area without losing functionality. With
our included scripts this would not have been possible.

### Mandatory Continuous Integration

From the beginning our projects
have had the ability to check them out, run all tests and publish releases.
This allowed us to rapidly add functionality while keeping up our basic hygiene. The
code remains clean and we can make sure it meets our basic requirements.

As we continued to improve, most of our projects have added [Preflights][preflights].
This complemented our existing continuous integration. The added benefit has been
keeping problems from ever reaching our master branch.

Our added emphasis in testing at various levels in the project improved our
confidence. Every build/test run would cover even more of the application and
edge cases.

Summary
===============================================================================

We have learnt alot from maintaining PowerShell projects over the past few years.
Our new projects are rock-solid. We try to have the following in every project:

* Consistent Layout
* Thorough Testing
* Single Responsibility Modules
* Continuous Integration

This has made our projects easier to understand and update.

Have your glue scripts turned into something bigger? Is it time to take it to
the next level?

[pester]: https://github.com/pester/Pester
[preflights]: {% post_url 2015-09-29-preflights-changed-our-world %}
[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
