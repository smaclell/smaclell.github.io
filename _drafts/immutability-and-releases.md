---
layout: post
title:  "Immutablity and Releases-1"
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

Rather than writing this as a single wall of thoughts I decided to break it up
into a nice little series.

When either
aspect changes frequently it saps team focus on shipping their software (TODO-review).

Immutable Package
===============================================================================

On our team we have tried for a long time to treat every build as completely
immutable. This single unchanged set of binaries is used in all our
environments and is left unchanged. We manage configuration and other settings
outside of this immutable package where possible. The first step in our
Deployment Pipelines is to convert from code to binaries and perform the most
essential verification. The package has become our unit of work and represents
a consistent way to share the releases. We use either normal files/folders or
package managers like [Nuget][nuget].

We have benefited greatly from having completely immutable packages. We
can depend on no changes to the code between when it was built and when it was
deployed. There is one and only one way for us to create our packages which is
repeatable and reliable. The exact revision of all code involved is included
in every package. We use this to trace our changes all the way back to
development. Another benefit is knowing exactly what changes have happened
since the last deployment which helps identify what commits cause defects.

When there is a defect it is clear that you should not adjust or tweak the
contents of a released package. This would violate the traceability and
introduce risks that it is done wrong compared to your reliable build process.
Rather than focus on changing the package the conversation shifts to which
package should be used instead. Maybe you rollback to a previous package or
create a new one with the fixes.

With keeping complete copies of every package you can run out of disk space in
a hurry! Hopefully your packages are not very large. Some applications created
massive packages which would result in gigabytes of packages every day. Careful
monitoring was required to make sure that we did not frequently run out of
space. We have been able to alleviate this somewhat by only keeping recent
packages or packages that have been promoted to production.

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
releases. Scrum Sprints lead to teams TODO flesh this out.

We ensure every application we build has a release process that given the same
input will produce the same output. All automated tests run associated with
each potential release. The entire process is automated from start to finish.
It is easy to trust each release and the process is completely repeatable.
We decided to release based on feedback built into our Deployment Pipeline.

When dates, manual steps, and large groups of people are involved an immutable
process can start to break down.

Hitting fixed dates that are far enough in the future is nearly impossible. Our
weather forecasts aren't even accurate two weeks from now. How could a creative
effort like programming accurately predict what will happen weeks or months
away. This is not a fault of the individuals creating the solution, but instead
a byproduct of what they will learn while creating the final solution.
Commonly, something will take much longer to complete than expected or a better
solution is found.

Keeping the process used to create the release unchanging and adjusting how
much is released can provide teams with the flexibility to get the job done.
The steps each release follows remains the same, but relaxing scope
commitments can help accommodate fixed release dates. If any stable build can
be released, releasing on the given date also becomes simpler. You can use any
previous build that passed the process. Your processes and constraints ensuring
releases meet an appropriate standard remain intact and you can always ship on
the agreed upon date.

Mandatory manual steps contribute to variability in every process. For legacy
application we contribute to manual testing is required to prevent regressions.
Visual or interactive websites or tools should be reviewed to ensure they
behave as expected. Performing the same steps with every release can violate
the immutability. These routine tasks are best done by machines which is why we
put so much emphasis on automation.

TODO: Flesh this out.
Trust erodes as the group gets bigger. It needs to be maintained by trust, more
process, enforcement/management, or culture/social pressure.

Trust that everyone will comply with the prescribed process becomes harder to
rely on as the social network scales. Bureaucracy and overhead to keep everyone
aligned increased dramatically with more people. The context for each change
is easily lost in amongst the larger discussion. Software development is truly
and exercise in herding cats (TODO - link). Company culture plays a very
important part in creating social pressure to reinforce positive aspects of the
process.

As the problem becomes more intractable people may double down on trusting the
process exclusively over the people performing the work. Barriers may be
erected to force the process to occur. This can be good or bad depending on if
the process is effective. When individuals cannot do their job or spend most of
their time working around a draconian process it is no longer acting in the
best interest of those involved to continue enforcing it.

The more light weight or flexible the process is the more it can accommodate various situations
and continue to evolve as the product and company change.
We are very flexible when it comes to manual testing and it is an option part
of our process thanks to the extensive automated testing.

The Extremes: Long, Massive, Short or Small
===============================================================================

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

immutable package - the binaries are sacred, if they are no good you need new binaries, mitigate the risk by reducing the surface area that changed
immutable process - you adjust your standard process based on the size of the change, compensating for risk accordingly
immutable releases - nothing changes, make another release, test it all, do it all

[nuget]: http://www.nuget.org