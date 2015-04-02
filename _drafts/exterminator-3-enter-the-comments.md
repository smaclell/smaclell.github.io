---
layout: post
title:  "Exterminators Week 3 - Enter the Comments"
date:   2015-03-30 00:09:07
tags: goals improvement career focus quality exterminator
---

Comments can be a great way to learn new code and document unintuitive
behaviour. Good comments succinctly explain why code was done a certain way and
are kept up to date. Bad comments repeat exactly what is happening in the code.
Sometimes comments can be abused and it would be better to update the code or
write tests instead.

This week I have found myself adding more comments to code than ever before.
I think this is partially due to the code I am in as I try to understand it and
also part of the culture on the [Exterminator][tribute] team. It is part of how
the team works and leaving the documentation better than how you found it is a
part of every code review.

The team tries to add comments to any code they touch to document the behaviour
they are seeing. For every weird bug we solve, we can save the next person who
reads the code time understanding why it works the way it does. Together, we
have been able to slowly grow the documentation and tests along with the
changes we are making, leaving the updated code better than we found it.

In the past I have tried to rely solely on unit tests or naming to describe the
code. This works great for new code where it is easy to understand how
different classes are connected. In [legacy code][legacy] code where there are
no tests and the behaviour is unclear, relying only on naming and relationships
is not enough. Good comments along side the code and meaningful names can
change something from unintelligible to usable.

So what makes a good comment?

1. **Documents intent, not what is being done.** Without recreating the exact
   moment and thinking from the original developer it can be impossible to know
   why code has been written a specific way.

   TODO: Avoiding multiple enumerations



2. **Kept up to date with the code.** As soon as comments fall out of date they
   are more dangerous than no comments at all. Out of date comments are
   misleading and could result in other developers (or you in 6 months) doing
   bad things with code. Think leaving a parameter ``null`` that will now throw
   an exception.

   The best way to keep comments up
   to date is keeping them with the code. Put comments right on your methods or
   around complex logic. Jeff Atwood takes this even further and believes
   ["The value of a comment is directly proportional to the distance between the comment and the code."][good-comments].

3. **Is straight to the point and used only as needed.** Too many comments will
   dilute your code. I prefer fewer comments and like to the let the code speak
   for itself. You are not trying to write a great novel with comments, so keep
   them short and as concise as possible. If there are many comments then maybe
   there is actually a problem with the design. The more you need to explain
   something clever that is happening the more likely you are being too clever.

Conclusion
-------------------------------------------------------------------------------

Good comments are a great way to explain code that is hard to follow. Use them
when needed

--- Thoughts ---

The code being commented might be behaving oddly or difficult to follow. A well
written comment the describes the intended behaviour is fantastic. 

Why, not what

Good comments say why something behaves the way it does. What it is doing is less
important and is ultimately a function of the code. Instead of documentation that
will get out of date use tests or executable specifications.

Use comments to show connections that would not be obvious

Abuse

Not a subsitute for good naming. Good names are better than comments can ever be.
Should not be used to spackle over a bad design. Could you change the code so the comment was not required. Comments can be a smell so be on the lookout.

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[good-comments]: http://blog.codinghorror.com/when-good-comments-go-bad/
