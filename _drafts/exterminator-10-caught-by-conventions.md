---
layout: post
title:  "Exterminators Week 10 - Caught By Conventions"
date:   2015-06-08 23:26:07
tags: conventions exterminator
---

This week I had the most thorough code review I have ever encountered. By then
end of the review there were over 100 comments. The reviewers diligently went
over every line of code and more often than not had something to say. At first
I was stunned by the feedback I was receiving, but one I realized why it all
made sense.

Excitement
===============================================================================

The changes I had made were to a codebase I never contributed to before and
using some tools I had only started using. The changes were for doing more
comprehensive testing of our system with a tool called [SpecFlow][specflow].
Remember when I first started on the team and was all optimistic after
working through some [legacy code][legacy]? That was also SpecFlow. Now weeks
later I was really excited to get back to these changes and implement more
tests using this amazing tool.

I am excited! I want to code! I am getting things done and this is awesome.
I work for a few days and get things working okay. Some hiccups around wierd
areas of our system, but overall I like what I have built.

Since this is a new codebase for me I start asking around to find out who the
experts are so I can have them review my code. After some searching I learn
there are two different groups who are the primary contributors to this
library. Great! Double review.

Prior to sending the review to the other teams, I have a few people from our
team review my changes. There are a few minor things I incorporate based on
their feedback. Then I send it out to the primary contributors.

Epic Code Review
===============================================================================

What Happened?!
===============================================================================

I was not familiar with the conventions already established in the codebase.

The comments were all my fault.

Lets Do That Again. Lemonade from Lemons
===============================================================================

Minimalist - Lower bar, Make learning easy
Automatic - Don't make me think
Favour Design - Make the right thing to do the easist thing to do

Takeaway
===============================================================================

New to a code base? Learn the conventions first.

[specflow]: http://www.specflow.org/
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
