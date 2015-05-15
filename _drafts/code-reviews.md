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

Reviews effectively communicate how the code base is changing.

Code reviews are a great way to share new ideas. Lately, I have been really
enjoying NUnit's options for data driven tests. By using these features
throughout code reviews I have created, I have been able to share them with our team.

Logic
===============================================================================

Code reviews are one of the few times you can evaluate code for logical issues.
Fundamental flaws with how algorithms fit together or are used. Humans make
horrible compilers and computers cannot truly understand how code is related.

What are logical issues? A problem with the decisions behind the code. Maybe
something simple like using the wrong value for a constant. Another example
would be two classes using one another in a confusing way. Or misleading
comments or parameters.

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