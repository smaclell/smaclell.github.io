---
layout: post
title:  "Immutablity and Releases"
date:   2014-09-22 23:11:07
tags: release process
---

What if your releases were immutable? Maybe your process or package was not
allowed to change in any way. Relaxing or solidifying some of the constraints
might change the way you think about your releases.

Building great software takes time. It is not an exact science and needs care
throughout the process to result in products that people will want to use.
Consistently being able to release quality software is a challenge and
balancing rapid iterations with craftsmanship is imperative.

As your practices around releasing software change over time you might be
tempted to take shortcuts. Perhaps your code needs to be compiled and creates
a package that your distribute or deploy. Maybe the way you perform
development, validation and time your releases has a consistent process that is
strictly adhered to. Allowing changes to either the resulting package or
process used to create it comes with trade-offs for each shortcut used.

Our team and company have tried different approaches making either the package
or process completely immutable to varying degrees. Knowing that these
important aspects of how you release software don't change can lead to more
trust in the resulting applications and more repeatable releases.

Immutable Package
===============================================================================

On our team we have tried for a long time to treat every build as completely
immutable. This single unchanged set of binaries is used in all our
environments and is left unchanged. We manage configuration and other settings
outside of this immutable package. The first step in our
Deployment Pipelines is to convert from code to binaries and perform the most
essential verification. The package has become our unit of work and represents
a consistent way to share the releases. We use either normal files/folders or
package managers like [Nuget][nuget].

We have benefited greatly from having completely immutable packages. We
can depend on no changes to the code between when it was built and when it is
deployed. There is one and only one way for us to create our packages which is
repeatable and reliable.

The exact revision of all code involved is included in every package.
We use this to trace our changes all the way back to
development and the changes included since previous packages. Knowing the exact
delta between any two builds helps with finding the root cause for defects.

When there is a defect it is clear that you should not adjust or tweak the
contents of a released package. This would violate the traceability and
can be a source of problems by not using the standard automation.
Rather than focus on changing the package the conversation shifts to which
package should be used instead. Maybe you rollback to a previous package or
create a new one with the fixes.

Keeping every package will cause you to run out of disk space in a hurry! This
caused us to shrink our packages, monitor how much space is left and cleaning
up old unused packages. If you are shipping a new version, N + 1, and are
currently at N then you should be able to remove every package from before N.
You can also prune intermediate packages that are not release candidates.

Immutable Process
===============================================================================

Some teams have adopted a very consistent release process. They release on the
same date every month. Their releases go through all the same validation. Our
releases have taken on aspects of this thanks to our Deployment Pipelines.
Maybe all releases need to go through a specific test environments. Perhaps all
commits need to build before they can be merged.

Processes cast in stone provide very clear working engagements between teams.
The expectations on all parties is crystal clear at all times. Upcoming
obligations are understood by everyone involved. What happens every release is
not a surprise and should be familiar to everyone after a few releases.

Teams working a regular cadence already have structure that promotes immutable
release processes. Sprints or iterations from agile practices provide a
consistent rhythm that teams use to perform their release processes. Aligning
releases to team rituals helps establish team norms and understanding.

We ensure every application we build has a release process that given the same
input will produce the same output. All automated tests run associated with
each potential release. The entire process is automated from start to finish.
It is easy to trust each release and the process is completely repeatable.
Release are based on feedback from our Deployment Pipelines.

Skipping or shortening on of the steps based on the size of change would not be
allowed.

Single Line Change
===============================================================================

The best way to put both these options to the test is to evaluate the time and
effort required to release a single change. The smaller the change the better.
Releasing should be easy to do and fast so that the team spends less time
releasing and more time building awesome applications. As you scale down the
size of a change the more apparent the overhead is the release process in
comparison to the time and effort for the change being made. The pinnacle is
changing a single line of code, which is effortless and the majority of the
cost can be attributed to the release process.

If the package is immutable you would create a new package for this small
change. The overhead is then effort required to make the package and the
storage it consumes. Slow build processes are particularly problematic and
establish the minimum time required to perform a release.

The overhead of the release process is clear. If validation must happen to be
confident no regressions are introduced then this adds to the overhead.
Delays in validation cycles or delayed shipping dates for immutable processes
further inflate the time required to release.

Mutable Packages

Quick, you found a problem with a release you are about to send to your
clients. What do you do?

Do you rebuild and ship the new package? Do you open up your release package
and stuff in new code/binaries/files to fix the problem? What about retesting?
Do your releases undergo any soak time? Does that need be repeated?

How long it takes for you to create, test and prepare new releases
fundamentally changes how you can respond. A simple test to know how long each
release takes would be to understand everything that would happen if you
changed a single line of code [TODO reference]. The answer to this question is
what makes up your value stream [TODO link] which makes us all the steps and
people between any change and delighting your customers.

However, people under pressure do unusual things. Perhaps there is some simpler
process that is used to fix errors after a release is made. It looks completely
different than the normal process but as a result may be much faster. Nothing
is free and faster includes trade-offs that must be made. Otherwise, why
wouldn't everything be release as fast as this new fix?

Maybe the
only thing that happens is building the new code and light testing of just the
area that changed. Proportional testing effort to mitigate the risks of the
small change required to fix the issue.

Depending on how your code is packaged
it may be possible to update just the component that changed instead all of the
software. Again this would mitigate potential risks for other parts of the code
which might be justifiable if you have a very large code base with good
boundaries.

Why can't everything be faster? Everything up until this point presumed that it
was not possible to make everything faster. Automation is not a silver bullet
that can solve all your problems but can certainly alleviate them. The
trade-off with automation is development time and maintenance with a resulting
reliability that is impossible to match through manual processes.

[nuget]: http://www.nuget.org