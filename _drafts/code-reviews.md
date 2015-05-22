---
layout: post
title:  "Code Reviews"
date:   2015-05-04 00:09:07
tags: code-reviews exterminator
---

This week I helped perform several code reviews. I think code reviews are a
fantastic way to share best practices, check for logical errors and help
improve our code.

Code reviews have become a standard practice for many teams. While on
the [Exterminators][tribute] I have the privilege to work with others who have
different code review style than my own.

As with programming there can be many styles of code reviews. No one style is
better than another. Different approaches have different advantages and
disadvantages.

This has caused me to reflect on what I think are the most important aspects of
code reviews and what to look for when doing them.

Conversation about Code
===============================================================================

TODO - People talking

For me code reviews have been a conversation about the code being reviewed and
the surrounding system. Together with the author and other reviewers we can:

* Share ideas, opportunities or challenges with/about the code
* Learn more about what is being done
* Communicate changes amongst the team

Everyone on the review is enriched by the process and hopefully comes away
having learnt something they did not know before.

My usual team would include two people on every review, an expert and a
learner. The expert would be intimately familiar with the system being changed
and the surrounding project. The learner could be anyone else and typically
someone who is less confident in their knowledge of the project. This helped our team
share knowledge about the changes being made and validate assumptions made
by people deeply immersed in the problem with a fresh pair of eyes.

Learning from reviews has helped ease the team into developer work outside
their area of expertise. Having seen enough changes and being supported by
reviewers we have been able to work more effectively as a team. With the
learner and expert reviewers it was often not long before the learners could
contribute as effectively as the experts.

Reviews effectively communicate how the code base is changing. We recently
worked on a new approach for some existing code. We shared the changes with the
team through code reviews. Each team member was able to provide valuable
feedback and influence the design. By the end of the reviews the whole team
understood the new changes.

On the team there are many great developers, but not all have extensive
experience with the platform or tools we are using. I have been using code
reviews to share knowledge of our platform and tools. This should only be a
minor part of any code review and can help to further the goal of learning and
sharing. Lately, I have been using NUnit's data driven tests and sharing these
new tools with the team. For others reviews I have been sharing more about the
LINQ syntax and operators for those new to .NET.

Logicically, Why
===============================================================================

Some code review styles are to interrogate the code/developer as a detailed
validation. Code reviews can be a great way to improve the code quality and
consistency. I don't think code reviews as a strict quality gate is a good use
of time and resources. Such validation is better left to manual testing or
other automated tools/validation. Instead, I try to use code reviews to delve
into the logic behind the code.

Code reviews are one of the few times you can evaluate code for logical issues.
Fundamental flaws with how algorithms fit together or are used. Humans make
horrible compilers and computers cannot truly understand how code is related.

What are logical issues? A problem with the decisions behind the code. Maybe
something simple like using the wrong value for a constant. Another example
would be two classes using one another in a confusing way. Misleading
comments or parameters. Logical issues center around why choices were made.

Stopping logical issues is important. Your code could compile and pass all the
unit tests, but with logical errors it is still broken. Logical errors can
lead to other defects and issues for your users. The longer logical errors
survive in the codebase the more likely they are to mislead other developers
who then cause defects as a result.

Unlike other development activities, code reviews provide a great opportunity
to step back and look at the code to find logical issues. Going through the
code one line at a time and looking for connections is a great way to find
relationships which do not make sense.

TODO - Spock picture - Ange or you doing a spock pose OR one of the guys at the office

Understand Why
===============================================================================

TODO: This why you have currently written about is more of a what. The original why was the core reason why the change was made at all.

Why was this done. Connects to what was done to accomplish the why.

I like to take the time to truly understand what I am reading and why it was
done the way it is. At the heart of any changes is a reason why they were made.

Understand why a certain change was implemented the way it has been can be a
challenge. Sometimes the code is not intuitive or the change was made in one
area to affect a completely different place. With some of the code reviews I
have done lately this can be quite a challenge.

Yet the developer chose to make the changes they did and in the area they
changed. Getting some insight into this choice helps me to better understand
their thought process. Reversing the through process then helps unravel
assumptions used to make decisions.


Wrapping Up
===============================================================================



TODO - Question mark

- Not QA
- Not enough
- How thorough?
- How big?
- Substance not style
- Learning
- Sharing
- Testing
- Communicating
- Not an interrogation
- Not the grammar police