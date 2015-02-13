---
layout: post
title:  "Immutablity Ideas"
date:   2014-09-22 23:11:07
tags: release process
---

immutable package - the binaries are sacred, if they are no good you need new binaries, mitigate the risk by reducing the surface area that changed
immutable process - you adjust your standard process based on the size of the change, compensating for risk accordingly
immutable releases - nothing changes, make another release, test it all, do it all

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