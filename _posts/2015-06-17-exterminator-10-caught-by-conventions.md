---
layout: post
title:  "Exterminators Week 10 - Caught By Conventions"
date:   2015-06-17 23:53:07
tags: learning code-reviews conventions exterminator
---

This week I had my most thorough code review ever. By the
end of the review there were over 100 comments. The reviewers diligently went
over every line of code and more often than not had something to say. At first
I was stunned by the feedback I was receiving, but once I realized why I was
receiving so much feedback did it all make sense.

Excitement
===============================================================================

This story starts with trying to contribute to a codebase I had not
contributed to before which used tools I was not familiar with. This code
used the tool [SpecFlow][specflow] for integration testing.
Remember when I had first started on the team and was all optimistic after
working through some [legacy code][legacy]? The reason I was optimistic was
because I had tried using SpecFlow and loved it. Weeks later, I was really
excited to use SpecFlow more and write more tests.

{% highlight gherkin %}
Scenario: Using SpecFlow
  Given the need for more testing
    And the desire to collaborate with testers
   When you write scenarios using "SpecFlow"
   Then the tests can be shared them with your team
    And the team can have fun writing tests together
{% endhighlight %}

I was pumped! I was coding! I got things done and it was awesome.
I worked for a few days until I had enough to cover the scenarios we wanted.
The tests did what there were asked, but were not pretty. There were some
hiccups around weird areas of our system. Overall I was happy with what I built.
We could now validate a moderately complicated scenario with some fun permutations.

Since I was new to the codebase, I started asking around to find out who the
experts were so I could have them review my code. After some searching I learnt
there are two different groups who are the primary contributors to this
repository. Great! Double review.

Prior to sending the review to the other teams, I had a few people from our
team review my changes. There are a few minor things I incorporate based on
their feedback. We thought my changes were good enough and were ready to merge
them. Then I sent out the code review to the primary contributors.

Epic Code Review
===============================================================================

The first team started to respond with a smattering of recommendations. Little
things I would not have understood on my own. They pointed out standard ways to
use the framework they had built which I had not done originally. I quickly
implemented their changes and was ready to move on.

Then the second team showed up in a big way. They went over every line of code
with a fine tooth comb. We work in different offices and due to the time
difference I did not see their feedback until I came into the office the next
day.

Their comments fell roughly into these categories:

* Grammar, spelling, whitespace and punctuation for Comments
* Patterns in the codebase
* Layering
* Framework usage
* Standard methods
* Casing and naming conventions
* Code formatting and style

This was incredibly frustrating. I spent days going back and forth on this pull
request.

What made it worst was very few of the comments seemed to be about the logic
behind the code and were on things I felt were superficial. The
[code review style][cr-style] was so different from my own it was
painful to adjust.

I struggled to understand **Why** the recommended changes were important.
How would their recommendations lead to a better product for our clients?

Eventually, I addressed the recommendations and merged the pull request.

What Happened?!
===============================================================================

This review was not about my code. The review was about how my code fit into
the codebase. It didn't fit in, which is why the pull request went so poorly.
The bad code review was my fault. I did not know the existing conventions and
violated most of them with my changes. Thankfully, my reviewers patiently went
through everything I had done and helped me correct the code.

I had been accustomed to working on different code bases with more relaxed
conventions. When you have a small service with great tests then conventions
are less as important. If you have a large codebase maintained by multiple teams
ensuring everyone is on the same page becomes a big deal. This project had
grown substantially and had several different groups of active contributors.
Keeping the developers aligned was important to the maintainers.

Conventions and consistently help make code more readable. As the code grows
and more people contribute standards become harder to enforce. If left
unchecked conflicting patterns or lack of standards can make code very
inconsistent and difficult to understand.

For this reason it was important to my reviewers that I follow the
conventions. By having strong conventions we would be able to continue delivering value
to our clients without slowing down as the codebase grows. This was their reason **Why**
conventions were so important.

As a new contributor it was important for me to learn and apply the standards
set out by the maintainers. This is good [Open Source Contribution Etiquette][etiquette]:

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
wanted to solve and ignored everything else. The problem I was trying to solve,
creating high level tests, is a common problem. Every team wants to do more
testing and be more effective at doing it. Aside from this initial code review
the tests we wrote were great and we want to keep doing it.

After I understood where I had gone wrong, not following the conventions, I
realized I would not be alone. Since the tests were so compelling I would hope
more teams would try using the same tools.
However, if others went through the experience I did they might be completely
turned off and never want to do it again. This was the case for another
developer on our team who participated in my first review.

To prevent the next set of people from having the same experience, I decided I
would work with the maintainers to help improve the learning experience.
The discussions centered on baking the conventions into the framework,
automating some of the conventions and minimizing/simplifying the conventions.

**Bake consistency into the design.** There were a number of standard practices
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
I am not invested what formatting is chosen. Pick one and move on.

Thankfully, the maintainers know exactly what they want the format to be. Even
better the majority formatting and style can be automatically enforced by
tools everyone already uses.

For the missing comments you can enable a compiler setting to make them
mandatory<a href="#ext-10-note-1"><sup id="ext-10-note-1-reverse">1</sup></a>.
We updated the [Resharper][resharper] settings in the solution so all new code
going forward would have the <em title="C#: tabs, always tabs">correct</em>
formatting. Having the formatting rules live with the code meant any special
rules used only by this project would not affect anything else. Updating them
would also be very easy.

With basic coding standards dealt with by the tools, code reviews can move onto
solving problems for our users.

**Minimize your conventions.** Having many conventions makes enforcing them
harder and can be overwhelming for new contributors. The fewer conventions
your contributors need to remember and apply the more they focus on their
code and not the conventions.

Since my initial review I have been discussing ways to relax the conventions with
the maintainers. Separating the absolutely mandatory standards from recommended
practices has helped clarify the standards for new contributors. Further
discussing the existing conventions helped me to understand why they were being
recommended.

Simplifying the conventions can make them easier to follow. In some cases using
more explicit conventions allows them to be followed more easily, i.e. you must
not perform assertions in
PageObjects<a href="#ext-10-note-2"><sup id="ext-10-note-2-reverse">2</sup></a>.
Conventions which are open to interpretation are sure to be a point of contention
and complicate code reviews.

Takeaway
===============================================================================

This turned out to be an interesting week and a great learning opportunity. My
big takeaway was the importance of learning a codebase's conventions before
trying to contribute.

Although my first review did not go smoothly the reviews since then have been
much better. I am very happy the maintainers have been receptive to my
suggestions. Together we have applied some of my thoughts for making the conventions easier
for new contributors:

* **Build It Into Your Design** - Make the right thing to do, the easiest thing.
* **Automate Coding Standards** - Don't make me think.
* **Minimize Conventions** - Shorten the learning curve.

I would encourage you to review your own conventions. How could you make them
simpler or easier for a new contributor?

<hr />

<a href="#ext-10-note-1-reverse"><span id="ext-10-note-1">1.</span></a> Filling in 250+ missing comments was also a brutal pull request, but necessary in the name of progress.

<a href="#ext-10-note-2-reverse"><span id="ext-10-note-2">2.</span></a> Tell, don't Ask in PageObjects

One of my favourite exchanges from the pull request was when both the reviewer
and I sent each other Martin Fowler links explaining the intent behind the
code. I was trying to have my code [Tell, not Ask][tell-dont-ask] and they responded
with for the rationale behind the [PageObjects][po] pattern.

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