---
layout: post
title:  "Immutablity and Releases"
date:   2015-03-25 23:14:07
tags: release process
image:
  feature: immutability-and-releases-rocks.jpg
---

What if your releases were immutable? What if your package or process was not
allowed to change in any way? Relaxing or solidifying how mutable your release
package or process are can change your releases.

Building great software takes time. It is not an exact science and needs care
throughout the process to result in products people will want to use.
Consistently being able to release quality software is a challenge and
balancing rapid iterations with craftsmanship is imperative.

As your practices around releasing software change over time, you might be
tempted to take shortcuts. Perhaps your code needs to be compiled and creates
a package to be distributed or deployed. Maybe the way you deploy, validate and
time your releases has a consistent process that is
strictly adhered to. Allowing changes to either the resulting package or
process used to create it comes with trade-offs for each shortcut taken.

Our team and company have tried varying degrees of immutable packages and
processes. The less changeable they become there can be better consistency and
other benefits/concerns.

Immutable Package
===============================================================================

On our team we have tried to treat every build as completely immutable. A
single unchanged set of binaries is used in all our environments without any
modifications after it is created. We manage configuration and other settings
outside of this immutable package. The first step in our Deployment Pipeline is
to convert from code to binaries and perform the most essential verification.
The resulting package has become our unit of work and represents a consistent
way to distribute the releases.

Immutable packages has benefit the team a great deal. We
can depend on no changes to the code between when it was built and when it is
deployed. There is one and only one way to create our packages which is
repeatable and reliable.

The exact revision of all code involved is included in every package.
We use this to trace our changes all the way back to
source control and identify the differences between packages. Knowing the exact
delta between any two packages helps with finding the root cause for defects.

When there is a defect it is clear the package should not be adjusted or
tweaked. This would violate the traceability and not using the standard
automation can introduce additional problems due to manual errors or
oversights. Rather than focus on changing the package directly, the
conversation shifts to which package should be used to replace the faulty one.
Maybe the client should rollback to a previous package or a new one should be
created with the fixes.

Keeping every package will cause you to run out of disk space in a hurry! This
caused us to shrink our packages, monitor how much space is left and cleaning
up unused packages. If you are shipping the version N + 1 and are
currently at N, you should be able to remove every package before version N.
You can also prune intermediate packages which are not release candidates.

Immutable Process
===============================================================================

Some teams have adopted a very consistent release process. They release on the
same date every month. Their releases go through all the same validation. Our
releases have taken on aspects of this thanks to our Deployment Pipelines.
Maybe all releases need to go through a specific test environments. Perhaps all
commits need to build before they can be merged.

Processes cast in stone provide very clear working agreements between teams.
The expectations on all parties is crystal clear at all times. Upcoming
obligations are understood by everyone involved. What happens every release is
not a surprise and should be familiar to everyone after a few releases.

Teams working at a regular cadence already have structure which promotes
consistent release processes. Sprints or iterations from agile practices
provide a rhythm teams can use to perform their release processes. Aligning
releases to team rituals helps establish team norms and regular deliveries.

We ensure every application we make has a release process that given the same
input will produce the same output. All automated tests run associated with
each potential release. The entire process is automated from start to finish.
It is easy to trust each release and the process is completely repeatable.
We choose when and what to release based on feedback from our Deployment
Pipelines.

Processes cast in stone don't deal well with change. Skipping or shortening on
of the activities based what has been changed would not be allowed. It is important
that the process facilitates incorporating feedback and learning from previous
attempts. Treating the process itself as a deliverable with each release and
iteratively refining aspects of it can help balance having an immutable process
with improving.

Single Line Change
===============================================================================

The best way to put how you release software to the test is to evaluate the
time and effort required to release a single change. The smaller the change the
better. Releasing should be fast and easy to do so the team spends less time
releasing and more time creating awesome applications. As you scale down the
size of a change the more apparent the overhead is for each release compared
to the time and effort to make the change. The pinnacle of this is changing a
single line of code, which is essentially effortless compared to a normal
release. By then measuring the time and effort for releasing a single line
change you can estimate the release overhead.

If the package is immutable you would create a new package for this small
change. The overhead is then effort required to make the package and the
storage it consumes. Slow build processes are particularly problematic and
establish the minimum time required to perform a release.

The overhead of the release process is clear. If validation must happen to be
confident no regressions are introduced then this adds to the overhead.
Delays in validation cycles or delayed shipping dates for immutable processes
further inflate the time required to release. Changes that take a day to
code, test and complete, but can only ship annually due to a yearly release
schedule are extremely impacted.

With a small change the temptation to alter either the package or process from
a normal release is greatest. What would you change about your releases? Why
would you want to change it? Would having the package or process be more or
less immutable help? These questions can lead you to find pain points in what
you do now.

Why Not Both
===============================================================================

I think the ideal is if every change is performed consistently, but can adapted
as needed. I favour completely immutable packages and light weight
flexible processes. The core activities ideally do not change,
but can be extended or reduced depending on the changes. If all changes are small
changes then releases should also be small.

Our releases have been from immutable packages since the beginning of the
project. The traceability has been phenomenal and helped us better understand
exactly what has been included in each release. When defects are found we know
the commit where they were introduced and which packages will be affected. Creating
new packages is fully automated and completely repeatable.

If we wanted to become more immutable with our packages we could incorporate
more environmental settings and configuration used to validate each release.
We strictly configure our applications, but encounter problems with environmental
effects which are not as strictly maintained. More constraints on these options would
remove differences and eliminate the issues they cause.

The major activities for our releases remain consistent, but we try to adjust
the finer details of what we do based on risk and complexity. This does not
meet the fully immutable ideals, but improves the team's ability to adapt to
changing circumstances and what being included. Where we try to strike a
balance is by automating all routine activities performed in the release
process. Planning, testing, documentation and coordination always happen and
are adjusted based on client needs.

Our current approach to risk mitigation could be improved. We are a very
developer focused and I personally have trouble testing my own code. The
assumptions I made when programming are still there when I try to think about
how to test my code. This leads to bad assumptions and blind-spots that are hard
to counteract. This is an area we consistently try to improve by expanding our
test coverage and spending more time with our clients.

Automated test suites provide consistent validation which finds regressions
and are an important part of our release process. However, not all test
suites are mandatory and there are some cases we have chosen to do manually on
demand. If we wanted to be more immutable we could release after all
validation has completed successfully and manually perform the extra tests or
find a way to automate them. We are currently discussing gating releases like
this based on all test suites.

I love how adaptable our process is and how easily we can update it.
It remains consistent thanks to automation and continues to evolve as we think
of new enhancements. Changes to our process ship like changes to our
application, in small safe increments along side the solutions it supports. What
remains flexible are the interactions with other teams that need a human touch.
Empathy and supporting others is much easier thanks to our light weight
process that can better adapt to their needs.

Considering immutable releases has helped me understand what I like most about
our releases, immutable packages and the flexible process. As we
locked down our packages and how they were built we simplified what needed to
be done to create them and the surrounding processes. From here we can focus on
working with others to build great things.

What in your release process needs to be more immutable? Is there something
that needs to change or be more flexible?

<hr />

*I would like to thank Matt Campbell for this original idea and the discussions
we have had about the concept.*
