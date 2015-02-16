---
layout: post
title:  "Immutablity and Releases"
date:   2014-09-22 23:11:07
tags: release process
---

What if your releases were immutable? What if your process or package was not
allowed to change in any way? Relaxing or solidifying some of the constraints
might change the way you think about your releases.

Building great software takes time. It is not an exact science and needs care
throughout the process to result in products people will want to use.
Consistently being able to release quality software is a challenge and
balancing rapid iterations with craftsmanship is imperative.

As your practices around releasing software change over time you might be
tempted to take shortcuts. Perhaps your code needs to be compiled and creates
a package to be distributed or deployed. Maybe the way you perform
development, validation and time your releases has a consistent process that is
strictly adhered to. Allowing changes to either the resulting package or
process used to create it comes with trade-offs for each shortcut used.

Our team and company have tried different approaches making either the package
or process completely immutable to varying degrees. Knowing these
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

When there is a defect it is clear you should not adjust or tweak the
contents of a released package. This would violate the traceability and
can be a source of problems by not using the standard automation.
Rather than focus on changing the package the conversation shifts to which
package should be used instead. Maybe you rollback to a previous package or
create a new one with the fixes.

Keeping every package will cause you to run out of disk space in a hurry! This
caused us to shrink our packages, monitor how much space is left and cleaning
up old unused packages. If you are shipping the version N + 1 and are
currently at N, you should be able to remove every package from before N.
You can also prune intermediate packages which are not release candidates.

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

Teams working at a regular cadence already have structure promoting immutable
release processes. Sprints or iterations from agile practices provide a
consistent rhythm teams can use to perform their release processes. Aligning
releases to team rituals helps establish team norms and consistency.

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
Releasing should be easy to do and fast so the team spends less time
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
further inflate the time required to release. Changes that take a day to
complete, test and prepare, but can only ship yearly due to a yearly release
process are extremely impacted.

With a small change the temptation to alter either the process or package from
a normal release is greater. What would you change? Why would you want to
change it? These questions can lead you to find pain points in what you do now.
Would going further towards or away from either immutable packages or process
help?

Why Not Both
===============================================================================

I think the ideal is if every change is performed consistently, but can adapted
as needed. I have come to favour completely immutable packages and light weight
flexible processes. The core activities ideally does not change,
but can be extended or reduced for smaller changes. If all changes are small
changes then releases should be very similar. It is not necessary to have a
completely immutable process, but is worthwhile to think of how it could help
improve your releases.

Our releases have been from immutable packages since the beginning of the
project. The traceability has been phenomenal and helped us better understand
exactly what has been included in each release. When defects are found we know
the commit that they were introduced and which releases will be affected. Creating
new packages is fully automated and completely repeatable.

If we wanted to become more immutable with our packages we could incorporate
more environmental settings and configuration used to validate each release.
We strictly configure our applications, but encounter problems with environmental
effects which are not as strictly maintained. More constraints on these options would
remove differences and eliminate the issues they cause.

The major activities for our releases remain consistent, but we try to adjust
the smaller things we do based on the risk or complexity of the release. This
does not live up to the fully immutable ideals, but improves the team's ability
to adapt to changing circumstances and nature of the changes. Where we try to
strike a balance is by automating all routine activities and running them for
every release. Planning, testing, documentation and coordination are always
happen and are adjusted depending on the changes.

Our current approach to risk mitigation could be improved. We are a very
developer focused and I know I have trouble testing my own code. The
assumptions I make when programming are still there when I try to think about
how to break my code. This leads to unknown unknowns that are extremely hard
to account for completely without exhaustive testing. This is an area we
consistently try to improve by expanding our test coverage and spending more
time with our clients.

I love how adaptable our process is and how easily we update and improve it.
It remains consistent thanks to automation and continues to evolve as we think
of new ways to enhance it. Changes to our process ship like changes to our
application, in small safe increments along side solutions it supports. What
remains flexible are the interactions with others that need a human touch.
Empathy and supporting others is much easier thanks to our light weight
process.

Considering immutable releases has helped me understand what I like most about
our releases, immutable packages and flexible process done consistently. As we
locked down our packages and how they were built we simplified what needed to
be done to create them to the point where the process. From here we can care
about working with others to build great things.

What in your release process needs to be more immutable? Is there something
that needs to change or be more flexible?

[nuget]: http://www.nuget.org