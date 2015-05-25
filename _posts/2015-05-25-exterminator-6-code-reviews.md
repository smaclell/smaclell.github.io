---
layout: post
title:  "Exterminators Week 6 - Code Reviews"
date:   2015-05-25 00:18:07
tags: learning code-reviews exterminator
---

This week I helped perform many code reviews. I think code reviews are a great
way for teams to communicate. This is the best time to ask
deep questions about the code and share information throughout the team.

Code reviews have become a standard practice for many teams I work with. While on the
[Exterminators][tribute] I have had the privilege to work with others who have
different code review style than my own.

For me code reviews are a conversation about the code being changed and
the surrounding system. Common code review themes include:

* Learning and sharing ideas
* Understanding the affected logic

Learning
===============================================================================

I think a review has been successful if you have learnt something new.

One team I was on included two people on every review, an expert and a
learner. The expert would be intimately familiar with the system being changed
and the surrounding code. The learner could be anyone else and typically the
learner would be someone new to the codebase. The expert could user their
knowledge to guide the changes and avoid issues. The learner would help by
being a fresh pair of eyes with a different perspective.

Learning from reviews has helped developers work outside their area of
expertise. Over time the learners will better understand the code and can
start contributing. It was not long before the learners could contribute
alongside the experts for any given project.

Code reviews can be used to align architectural decisions. On a recent
project we shared a refactoring with the team using code
reviews. The early reviews had more team members to build consensus for the
direction we were headed. As the changes progressed every member of the team
was able to see the new changes applied. Knowing what was happening helped the
team work together toward the common goal.

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
Humans make horrible compilers and computers cannot truly understand how code interacts.

Logical issues are problems with the decisions behind the code.

* Algorithmic flaws.
* Using the wrong constant value.
* Confusing classes.
* Misleading comments or parameters.

Stopping logical issues is important. Your code can compile and pass all the
unit tests, but with logical errors it is still broken. The longer logical errors
survive in a codebase the more likely they are to mislead other developers
who then accidentally cause defects.

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

There are many different code review styles, but my favourite is to treat
code reviews like a conversation.

Code reviews are a two way street. Both the author and reviewers should
actively participate and ask questions. Together the author and reviewers can
learn from one another and better understand the code being changed.

What was the last thing you learnt from a code review? Did you understand how
the bugfix you reviewed fixed the problem it was intended to solve?

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[m1]: /posts/recursive-mocks/
[m2]: {% post_url 2015-04-16-linq-to-moq %}
[moq]: https://github.com/Moq/moq4#readme