---
layout: post
title:  "Exterminators Week 10 - Caught By Conventions"
date:   2015-06-08 23:26:07
tags: conventions exterminator
---

This week I had the most thorough code review I have ever encountered. By then
end of the review there were over 100 comments. The reviewers diligently went
over every line of code and more often than not had something to say. At first
I was stunned by the feedback I was receiving, but once I realized why I was
receiving so much feedback did it all made sense.

Excitement
===============================================================================

The changes I had made were to a codebase I never contributed to before and
using some tools I had only started using. The changes were for doing more
comprehensive testing of our system with a tool called [SpecFlow][specflow].
Remember when I first started on the team and was all optimistic after
working through some [legacy code][legacy]? That was also SpecFlow. Now weeks
later I was really excited to get back to these changes and implement more
tests using this amazing tool.

TODO: Specflow snippet

I am excited! I want to code! I am getting things done and this is awesome.
I work for a few days and get things working okay. Some hiccups around wierd
areas of our system, but overall I like what I have built. The final code was
larger than I wanted. We were validating a moderately complicated scenario and
I wanted to make sure we had our bases covered.

Since this is a new codebase for me I start asking around to find out who the
experts are so I can have them review my code. After some searching I learnt
there are two different groups who are the primary contributors to this
library. Great! Double review.

Prior to sending the review to the other teams, I have a few people from our
team review my changes. There are a few minor things I incorporate based on
their feedback. Then I send it out to the primary contributors.

Epic Code Review
===============================================================================

The first team started to respond with a smattering of recommendations. Little
things I would not have understood on my own. They pointed out standard ways of
using the tools they added to the underlying frameworks. I was made the changes
they requested quickly.

Then the second team showed up in a big way. They went over every line of code
with a fine tooth comb. We work in different offices and due to the time
difference I did not see their feedback until I came into the office the next
day.

The comments fell roughly into these categories:

* Grammar, spelling, whitespace and punctuation for Comments (Simple Present Tense)
* Patterns in the codebase
* Layering
* Framework usage
* Standard methods
* Casing and Naming conventions
* Code Formatting and Style

This was incredibly frustrating. I spent days going back and forth on this pull
request.

What made it worst was very few of the comments seems to be about the logic
behind the code and for me were mostly on what I thought were superficial
aspects. The [code review style][cr-style] was so different from my own it was
painful to adjust.

I struggled to understand **Why** the recommended changes were important.
How would the recommendations lead to better product for our clients?

Eventually, I addressed the recommendations and merged the pull request.

What Happened?!
===============================================================================

This was not about my code. The review was about how my code fit into the
codebase. It didn't and the reason this went so poorly was my fault. I did
not know the conventions and happened to violate most of them. Thankfully,
my reviewers patiently went through all of my code and showed me.

I had been used to working on different code bases with more relaxed
conventions. When you have a small service with great tests then conventions
are not as important. If you have a large codebase maintained by multiple teams
ensuring everyone is on the same page becomes a big deal. This project had

Conventions and consistently help make code more readable. As the code grows
and more people contribute these standards become harder to enforce. If left
unchecked conflicting standards can make it difficult to understand the code.

For this reason it was important to my reviewers that we maintain the
conventions. By having strong conventions we would be able to delivering value
for our clients without slowing down. This was their reason **Why**
conventions were so important.

As a new contributor it was important for me to learn and apply the standards
set out by maintainers. This is just [Open Source Contribution Etiquette][etiquette]:

> When you contribute fixes or new features to an open source project you should use
> the existing coding style, the existing coding patterns and stick by the active
> maintainer's choice for his code organization.
>
> The maintainer is in for the long-haul, and has been working on this code for longer
> than you have. Chances are, he will keep doing this even after you have long moved
> into your next project.
>
> <cite>From [Open Source Contribution Etiquette][etiquette] by [Miguel de Icaza][miguel]</cite>

I didn't apply the existing conventions and learnt the hard way with my review.

Making Lemonade from Lemons
===============================================================================

I didn't know the conventions when I started coding. Instead I had a problem I
wanted to solve. The problem I was trying to solve, creating high level tests,
is a common problem. The specifications you create from SpecFlow are fantastic
and have changed how I work with our testers.

After I understood where I had went wrong by not following the conventions I
realized I would not be alone. Since the tests were so compelling I would hope
more teams would try to use the tools and see if they address their needs.
However, if others went through the experience I did they might be completely
turned off and never want to do it again. This was the case for one of the
developers on our team who watched as the review unfolded.

To prevent the new set of people from having the same experience I decided I
would work with the maintainers to help improve the on boarding experience.
The discussions centered around baking the conventions into the framework,
minimizing the number of conventions and making the simple conventions
automatic.

**Baked consistency into the design.** There were a number of standard practices
done by developers which could be built right into the testing frameworks.
Using the framework to creates consistency throughout the codebase allows the
running program and complier to guide developers into doing the right thing. I
love frameworks, like [Moq][moq], that help you fall into the pit of success
without realizing it thanks to their intuitive design. For our codebase, I had
been using one class to solve a problem and should have been using another.
Changing the framework so it is impossible to use the wrong class enforces the
expected behaviour.

**Make conventions automatic.** There are naming, formatting and styling conventions I
could care less about and yet foster such intense debate. [Death to the space infidels][space]!
Like Jeff Atwood, I believe consistent formatting is worth fighting for, but
I am not investing what formatting is chosen.

Thankfully, the maintainers know exactly what they want the format to be. Even
better the majority formatting and style can be automatically enforced by
tools everyone already uses.

For the missing comments you can enable a compiler setting to make them
mandatory<a href="#ext-10-note-1"><sup id="ext-10-note-1-reverse">1</sup></a>.
We updated the [Resharper][resharper] settings in the solution so all new code
going forward would have the <em title="In C#: tabs, always tabs">correct</em>
formatting. Even better put the special rules for formatting the code directly
into the solution.

With basic coding standards dealt with by the tools, code reviews can move onto
bigger and better things. You can move past indentation, spacing and brackets
to does this deliver what we wanted for our users.

**Minimize your conventions.** Having many conventions makes them harder to
enforce and can be overwhelming for new contributors. The fewer conventions
your contributors need to remember and apply will help them be more productive.

Since my initial review I have been discussing relaxing the conventions with
the maintainers. Separating the absolutely mandatory standards from recommended
practices has helped reduce what is required for new contributors. Further
discussing the existing conventions helped me to understand why they were being
recommended.

Simplifying the conventions can make them easier to follow. In some cases using
more explicit conventions allows them to be followed more easily, i.e. you must
not perform assertions in
PageObjects<a href="#ext-10-note-2"><sup id="ext-10-note-2-reverse">1</sup></a>.


Takeaway
===============================================================================

Conventions are important.
New to a code base? Learn the conventions first.

To make your easier:

* **Minimize Conventions** - Lower bar, Make learning easy
* **Automate Coding Standards** - Don't make me think
* **Build It Into Your Design** - Make the right thing to do the easiest thing to do



<hr />

<a href="#ext-10-note-1-reverse"><span id="ext-10-note-1">1.</span></a> Filling in 250+ missing comments was also a brutal pull request, but necessary in the name of progress.

<a href="#ext-10-note-2-reverse"><span id="ext-10-note-2">2.</span></a> Tell, don't Ask in PageObjects

One of my favourite exchanges from the pull request was when both the reviewer
and I sent each other Martin Fowler links explaining the intent behind the
code. I was trying to have my code [Tell, not Ask][tell-dont-ask] and responded
with for the [PageObjects][po] pattern.

I learnt how the standard thinking was reversed based on the problems being
solved and how the objects are reused. I had put assertions right into a
PageObject which is apparently not cool. Neato.

[specflow]: http://www.specflow.org/
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[cr-style]: {% post_url 2015-05-25-exterminator-6-code-reviews %}
[etiquette]: http://tirania.org/blog/archive/2010/Dec-31.html
[miguel]: https://twitter.com/migueldeicaza
[moq]: https://github.com/Moq/moq4/wiki/Quickstart
[space]: http://blog.codinghorror.com/death-to-the-space-infidels/
[resharper]: https://www.jetbrains.com/resharper/
[tell-dont-ask]: http://martinfowler.com/bliki/TellDontAsk.html
[po]: http://martinfowler.com/bliki/PageObject.html