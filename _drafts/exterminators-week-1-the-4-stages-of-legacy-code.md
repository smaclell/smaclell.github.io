---
layout: post
title:  "Exterminators Week 1 - The 4 Stages of Legacy Code"
date:   2015-02-28 23:11:07
tags: process improvement legacy
---

Last week was my first week on the new team, [Exterminators][tribute]. I got to
dive right in and start digging into our code immediately. The transition took
me through many emotions, but after the first week I feel optimistic for what
comes next.

<div class="disclaimer">
This is my personal blog and does not represent the views and opinions of my
employer. While I do talk about the code and general areas I am working on, the
challenges discussed here are my perspective while dealing with a limited part
of the whole system.

The difficulties I found while learning about the system are my own and are
part of the learning curve. After one week in I feel much better and encourage
you to read more for the whole story.
</div>

Years ago I read the book [Working Effectively with Legacy Code][legacy] and
absolutely loved it. This book changed how I look at code. I now only saw code
as black and white, tested and not tested. The techniques in the book show how
even the most challenging code can become testable. I began to adopt the book's
definition of Legacy code, **Legacy code [is] code without unit tests**.

Fast forward to the present and my [current rotation][tribute] where I am
learning tons from code I have never seen before. Sadly it has pockets of
legacy code. For years I have been privileged to work on newer projects
where I could include tests from the start. I always felt safe knowing the
tests were there to protect me. Now working on the legacy code my comfortable
safety net is gone.

Overwhelmed
===============================================================================

At first I was overwhelmed by the code I was going through. Without tests I
didn't have the confidence that my changes would do what I wanted without other
side effects.

Typically, I use the tests to get a basic understanding for how code
works. Using that knowledge I can start the normal TDD cycle (Red, Green,
Refactor) to make small changes until I was done. If there are no tests then
I need to reverse engineer what the code should do. Code not designed to be
testeable is harder to start the normal TDD cycle.

From the outside looking in it is easy to make assumptions about how easy
something would be. The extra distance between you and the problem makes it easy
to trivialize problems. Techniques for teasing apart code or safely making
changes are easy to talk about, but hard to put into practice. Having never
worked in these codebases I had an overly optimistic view of how easy it would
be.

Despair
===============================================================================

In the middle of the week I felt like giving up. The feeling of being
overwhelmed by the challenge seemed like too much. I thought I knew what I was
getting into, but apparently had underestimated it. Things that were normally
easy in the code I was familiar with came much harder.

I always feel like an [imposter][imposter]. Looking at the code made me feel
like I had no right to be here. Maybe I don't. I missed out on many of the
"Basics" that my other co-workers take for granted because I did not take a
standard computer science degree. This has caused me to work harder and try to
learn more about the basics, but I always feel like I have gaps. The unknowns
you cannot know because you don't know what you are missing.

Acceptance
===============================================================================

I realized my feels were perfectly natural and part of understanding my
limits. It is okay to not know all the answers. Learning takes time and I need
to be willing to take the time it needs.

It took most of the week to do and I was finally able to accept the legacy code
for what it is. The code works as intended and is only missing a few tests to
be much better. Only pockets of the code are like this and so knowing where
they are can better help me deal with them.

Things are the way they are, I can accept that. Getting over my mental blockers
will take effort, but is the starting point for improving. Accepting reality
for what it is provides will help me move on and understand what is possible.

Hope
===============================================================================

As the week progressed I felt I was beginning to see things more clearly and
understand how I could help. Knowing there is a path where I can help improve
the current state and contribute to the team gave me hope.

I spent all of Friday working on something new. The morning was slow at first,
but as I got further my ideas took shape. If tests were the problem holding me
back from being confident and I needed more of them to feel safe then the
solution is to add more. Adding Unit Tests when I need them. Wrap areas I will
affect in larger integration tests to feel safer before doing more changes.

With these tests in place I no longer was overwhelmed or feeling low. For the
first time this week I was filled with hope that I could make a difference. I
will share more about what I learned and the new tests I added in later posts.
For now it is enough to know that I am excited for these early wins on the path
to shrinking our legacy code.

If you are feeling lost or overwhelmed with a big challenge you aren't alone.
Understanding this is the beginning and using small improvements can be the
motivation you need to keep going and pursue a future filled with hope.

[legacy]: http://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052
[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[imposter]: http://www.hanselman.com/blog/ImAPhonyAreYou.aspx
