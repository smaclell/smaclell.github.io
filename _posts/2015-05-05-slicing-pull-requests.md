---
layout: post
title:  "Slicing Up Pull Requests"
date:   2015-05-05 23:38:07
tags: brain-storming pull-requests exterminator
---

When writing the previous post,
[Exterminators Week 5 - Pull Requests](/posts/exterminator-5-pull-request-explosion/), I started brainstorming ways
you could slice up your work into pull requests. It seemed like a fun list so I
have decided to share them with you. Enjoy.

I have been having too much fun creating a flurry of pull requests. It has been
a great way to break down my thoughts into small shippable pieces. I am still
trying to find the <em title="just right">"goldilocks"</em> number and size for
my pull requests.

If you are stuck thinking about ways to break down a large feature try using
this list. They can help you find ways to slice up your work so you can ship
more easily. These helped me shrink what would otherwise have been massive pull
requests down to more manageable sizes.

**WARNING:** There is such thing as *TOO MANY* pull requests. If you follow all
of these ideas you might find your belongings immersed in Jello or suddenly
missing.

<figure class="image-center">
	<img src="/images/cucumber-slices.jpg" alt="A cutting board with sliced cucumbers on it.">
	<figcaption>
	Breaking down a feature into pull requests is like cutting a cucumber into slices. Delicious.
	</figcaption>
</figure>
<!-- from http://www.publicdomainpictures.net/view-image.php?image=32801&picture=cucumber-slices&large=1 -->

<strong><span id="slice-tests">1.</span> Start with Tests</strong>

Create a pull request with only tests. If the tests affect multiple
functional areas consider making a pull request for each area. This
works phenomenally well with [legacy code][legacy] where starting by adding
tests can help you better understand the code and establish the current
behaviour.

You might find as you keep biting off different pieces you have even more tests
you want to add which don't go well with the other changes you are making.
Not a problem. Slice off another pull request for the new tests and
keep on cookin'!

<strong><span id="slice-prototype">2.</span> Share the Prototype!</strong>

You could quickly program a small prototype and share it with others to get
feedback. I would not recommend merging or trying to ship your prototype, but
showing it to others and hearing what they have to say about the general
direction is invaluable.

<strong><span id="slice-early-testing">3.</span> Early Testing</strong>

Is there something risky you could complete early or partially? Could you
finish just enough to test out a fundamental building block? You can carve off
functionality you want to test separately into its own pull request(s).
Early testing can validate the work you are doing before your solution becomes
more complicated. Rapid testing with pull requests can help isolate defects by
reducing the amount of code that could be responsible.

<strong><span id="slice-highlight">4.</span> Highlighting the Difference</strong>

Particularly confusing, complicated or dangerous changes can benefit from
their own pull requests. Reviewing delicate changes independently will help
reviewers focus on the changes being made and go deeper into the code than
if it was mixed in with other changes. The most extreme version of this would be
to create a pull request for a single particularly interesting commit.

<strong><span id="slice-single-responsibility">5.</span> Single Responsibility</strong>

Any update with a single purpose is a good candidate for a standalone pull
request. Focusing on one thing makes reviewing such pull requests easier and
generally makes them smaller.

A special case of this would be a pull request containing only code deletions.
Deleting code can be safer and is much easier to review than when code is
added/removed throughout a single pull request.

<strong><span id="slice-setup">6.</span> Setting Up</strong>

Sometimes there is more setup than expected which could be split into separate pull requests.
You could have a pull request for interfaces you want to use. Adding
new tables or data access to allow for the new feature you are doing.

Anticipating future design constraints can be a slippery slope and lead to designing for every possible use
case. Pick the most important thing, create a pull request implementing it,
ship the pull request, repeat. Don't over think it.

<strong><span id="slice-alone">7.</span> Refactoring Alone</strong>

Do refactoring as a separate pull request. Some refactoring can get messy
and touch more code than you planned to affect, i.e. any renaming for
popular classes. If these are mixed in with other updates they can hide what is
really important about the other changes.

<strong><span id="slice-new-old-cutover">8.</span> New Code, Old Code, Cut Over</strong>

Place as much of the new code as possible into separate pull requests. When you
are ready add more pull requests to integrate the new code with the old code. You can think
of this overall strategy as combining [Setting Up](#slice-setup), [Refactoring Alone](#slice-alone)
and [Highlighting the Difference](#slice-highlight) together to theme a series of pull requests.

<strong><span id="slice-iceberg">9.</span> The Iceberg (a.k.a Keystoning)</strong>

Like the [New Code, Old Code, Cut Over](#slice-new-old-cutover) and [Setting Up](#slice-setup), you can begin by making pull
requests for parts of the code not yet visible to users. Build up the functionality
in small pull requests and when you are finally ready, add the UI to hold
everything together (like the [keystone][keystone] on a bridge). This works
great when most of the code is not visible (like the other 90% of most
icebergs) to the end users and can be slowly built up over time.

You can combine this approach with [feature flags][toggle] to release the code
into the wild and then only turn it on for specific users/clients. This is a great way
to separate the release and deployment of new features. When you are fully
confident the new features are ready you can enable them as needed. After you
have proven the feature behaves as expected you can then remove the feature flag.

<strong><span id="slice-top-to-bottom">10.</span> Top to Bottom</strong>

Take a full slice from top to bottom for a simple change. This pull request
will help your reviewers by showing them all the layers affected. Doing a top
to bottom change can be hard without getting too big. It will work better if
you can keep the changes as a small wedge within the code that you gradually expand. If you
can make the first pull request smaller or only affect part of the
functionality it may be easier to get started and/or review the code.

<strong><span id="slice-different">11.</span> Different Repos, Different Reviews</strong>

If your project is broken up across different repositories, binaries or
services then each of the code changes should be performed using different pull
requests. This is probably the norm for most tools, but sometimes your tools
will allow you to combine disjointed components together into one mega code
review. Don't do it! If they are independent enough to be in different
repositories, binaries or services then they deserve different pull requests.

<strong><span id="slice-final">12.</span> The Final Once Over</strong>

If you have done many small pull requests up until this point it can be worth
skimming over all the changes and seeing if anything else should be done. If
there is more that can be improved, use another pull request to make it happen.
Repeat as needed.

I hope you liked this list and try it out soon. What other ways do you use to
break up large changes?

<hr />

I would like to thank my coworker and friend Travis for discussing this post
with me. He helped me organize the ideas and brainstorm a bit. Thanks Buddy.

[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[keystone]: http://en.wikipedia.org/wiki/Keystone_(architecture)
[toggle]: http://en.wikipedia.org/wiki/Feature_toggle
