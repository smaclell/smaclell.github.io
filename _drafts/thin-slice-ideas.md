---
layout: post
title:  "Slicing Up Pull Requests"
date:   2014-09-01 00:09:07
tags: pull-requests exterminator
---

When writing the previous post,
[Exterminators Week 5 - Pull Requests][explosion], I started brainstorming ways
you could slice up your work into pull requests. It seemed like a fun list so I
have decided to share them with you. Enjoy.

I have been having too much fun creating a flurry of pull requests. It has been
a great way to break down my thoughts into small shippable pieces. I am still
trying to find <em title="just right">"goldilocks"</em> number and size for
my pull requests.

If you are stuck thinking about ways to break down a large feature so you can
ship it more easily try some of the items from this list. These helped me
shrink what would otherwise be massive pull request down to size.

**WARNING:** There is such thing as *TOO MANY* pull requests. If you follow all
of these ideas you might spontaneously find your things immersed in Jello.


1. Start with Tests

Create a pull request with nothing, but new tests. If the tests affect multiple
functional areas consider breaking the pull request down even further. This
works phenomenally well with [legacy code][legacy].

You might find as you keep biting off different pieces you have even more tests
you want to add that are too big to go with the other changes you are making.
This is not a problem. Slice off another pull request for the new tests and
keep on cooking!

2. Share the Prototype!

You could quickly program a small prototype and share it with others to get
feedback. I would not recommend merging or trying to ship your prototype, but
showing others and hearing what their ideas about the general direction is
invaluable.

<span id="slice-setup" />
3. Setup

Sometimes there is more setup than expected. Help the setup changes stand on
their own by having them reviewed apart from other changes. You could start
with interfaces you want to use. Add new tables or data access to allow for the
new feature you are doing.

This can be a slippery slope while you try to design for every possible use
case. Pick the most important thing, create the pull request implementing it,
ship it and repeat.

<span id="slice-isolate" />
4. Isolate Refactoring

Do any refactoring as a separate pull request. Some refactorings can get messy
and touch alot more code than you planned to affect, i.e. any renaming for
popular types. If these are mixed in with other updates they can hide what is
really important about the other changes.

<span id="slice-tidy" />
5. Clean Up

Use a separate pull request to delete code and perform any necessary cleanup.
Reviewing only deletions can be much easier than other when code is
added/removed throughout.

6. New Code, Old Code, Cut Over

Place as much of the new code as possible into separate pull requests. When you
are ready have more pull requests to integrate with the old code. You can think
of this as the overall strategy combining [Setup](#slice-setup), [Isolate Refactoring](#slice-isolate)
and [Clean Up](#slice-tidy).

7. The Iceberg or Keystoning

Like the previous option and [Setup](#slice-setup), you begin by making pull
requests for parts of the code not visible to users. Build up the functionality
in small pull requests and when you are finally ready add the UI to hold
everything together (like the [keystone][keystone] on a bridge). This works
great when most of the code is not visible (like the other 90% of most
icebergs) to the end users and can be slowly built up over time.

You can combine this approach with [feature flags][toggle] to release the code
into the wild and then only turn it on for specific users. This is a great way
to separate the release and deployment of new features while ensuring they are
only available once you are fully confident.

7. Single Responsibility

Any time you are are making a targeted updated with a single purpose it is a
good opportunity for a standalone pull request. Focusing on one thing makes
reviewing such pull requests easier and generally makes them smaller.

7. Highlighting the Difference

Particularly confusing, complicated or dangerous changes could benefit from
their own pull request. Reviewing delicate changes on their own helps
reviewers dig deeper into the code. The most extreme version of this would be
to create a pull request for a particularly interesting single commit.

7. Slice Top To Bottom

Take a full slice from top to bottom for a simple change. This pull request
will help your reviewers by showing them all the layers affected. Even better
if the change adjust one small part of the functionality on the way to the
overall feature. You can also continue adding more and more of the feature
around the initial wedge.

8. Different Repos, Different Reviews

If your project is broken up across different repositories, binaries or
services then each of the code changes should be performed using different pull
requests. This is probably the normal for most tools, but sometimes your tools
can allow you to combine disjointed components together for one mega code
review. Don't do it! If they are independent enough to be in different
repositories, binaries or services then they deserve different pull requests.

9. The Final Review

If you have done many small pull requests up until this point it can be worth
skimming over all the changes and seeing if anything else should be done. If
there is more that can be improved pick another item on this list and keep
going.

I hope you liked this list and try it out soon. What other ways do you use to
break up large changes?

[explosion]: {% post_url 2015-04-28-exterminator-5-pull-request-explosion %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[keystone]: http://en.wikipedia.org/wiki/Keystone_(architecture)
