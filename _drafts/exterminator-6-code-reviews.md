---
layout: post
title:  "Exterminators Week 6 - Code Reviews"
date:   2015-05-25 00:09:07
tags: learning code-reviews exterminator
---

This week I helped perform many code reviews. I think code reviews are at
their core a chance to the team to communicate. This is the best time to ask
deep questions about the code and share information throughout the team.

Code reviews have become a standard practice for many teams. While on the
[Exterminators][tribute] I have the privilege to work with others who have
different code review style than my own.

For me code reviews are a conversation about the code being reviewed and
the surrounding system. Common code review themes include:

* Learning and sharing ideas
* Understanding the logic affected by the changes

Learning
===============================================================================

I think a review has been successful if at least one person has learnt
something new.

One team I was on would include two people on every review, an expert and a
learner. The expert would be intimately familiar with the system being changed
and the surrounding project. The learner could be anyone else. Typically the
learner would be someone new to the codebase. The expert could user their
knowledge to guide changes and avoid issues. The learner would help by being a
fresh pair of eyes.

Learning from reviews has helped developers work outside their area of
expertise. Over time the learners will better understand the code and can
start contributing. It was often not long before the learners could
contribute alongside the experts.

Code reviews can be used to align on architectural direction. On a recent
project we shared a refactoring we were working on with the team using code
reviews. The early reviews had more team members to build consensus for the
direction we were headed. As the changes progressed every member of the team
was able to see the new changes applied. Knowing what was happening helped the
team work together more effectively.

Reviews can be a great place to learn a new coding technique or library. I
learnt some [nifty][m1] [ways][m2] you can use [Moq][moq] lately from a code
review and since been sharing them with the rest of the team. The team has also
been great at letting me know when I get carried away using a new technique.
I have been using NUnit's features for data driven tests heavily which for some
team members is hard to read. This was valuable feedback; I was able to work
with the reviewers to update the code so it was easier to understand.

Logic
===============================================================================

Code reviews are one of the few times you can evaluate code for logical issues.
Fundamental flaws with how algorithms fit together or are used. Humans make
horrible compilers and computers cannot truly understand how code is related.

Logical issues are problems with the decisions behind the code.

* Using the wrong constant value.
* Two classes interacting with one another in a confusing way.
* Misleading comments or parameters.

Stopping logical issues is important. Your code could compile and pass all the
unit tests, but with logical errors it is still broken. Logical errors can
lead to other defects and issues for your users. The longer logical errors
survive in a codebase the more likely they are to mislead other developers
who then cause defects as a result.

Unlike other development activities, code reviews provide a great opportunity
to step back and look at the code to find logical issues. Going through the
code one line at a time and looking for connections is a great way to find
relationships which do not make sense.

Behind the logic for the code is a whole series of the decisions the other
developer has made. Talking about those decisions can help validate them or
expose other assumptions. The less I understand the code the more important it
is for me to be able to follow the developer's reasoning.

A Conversation
===============================================================================

There are many different styles of code review, but my favourite is to treat
them like a conversation.

Code reviews are a two way street. Both the author and reviewers should
actively participate and ask questions. Together the author and reviewers can
learn from one another and better understand the code being changed.

What was the last thing you learnt from a code review? Did you understand how
the bugfix you reviewed fixed the problem it was intended to solve?

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[m1]: {% post_url 2015-04-14-recursive-mocks %}
[m2]: {% post_url 2015-04-16-linq-to-moq %}
[moq]: https://github.com/Moq/moq4#readme