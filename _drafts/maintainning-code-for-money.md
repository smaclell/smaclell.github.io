---
layout: post
title:  "Maintaining Code For Money"
date:   2015-04-16 00:27:57 -4:00
tags: refactoring maintenance priorities
---

Refactoring is fun. Taking code and transforming how it fits together without
breaking it can be art. Getting carried away with tweaking your code and
continuously refactoring can be a problem. Trying to clean up existing code or
add more tests is time consuming. Before you try to maintain existing code it is
really important to know whether your effort will be worth it. This post
examines different stages in the code life cycle and how they shift how much
you should invest in cleaning up the code.

I like having a job. Every day when I go to work I am happy they let me in and
code up a storm. The important difference between my job and a really kick ass
hobby is that I get paid. We are a business and staying in business is
important for our customers, me and my family.

Going deep on an improvement you are making is great. The deeper
you get the more important it is to understand why you are making the change.
What will the impact be? How will the change help your users?

When it comes to refactoring and maintaining code I think this especially tricky. The more entangled
the code is the more I want to "fix" it. Beautiful code is something to be
admired and even pursued, but only as a means to an end. At the end of the day
you still have to ship and support your product.

I think it is important to think about when you should refactor, how much to
change, when to update code and what the long term benefit will be of what you are doing. Balancing
your desire to do the right thing and where to focus your efforts will result
in a better product with less effort.

A New Dawn
===============================================================================

<figure class="image-center">
	<a data-flickr-embed="true"
		href="https://www.flickr.com/photos/michaelmattiphotography/9448609846/"
		title="Evergreen Mountain Lookout Sunset by Michael Matti">
		<img
			src="https://farm8.staticflickr.com/7415/9448609846_c47a62b97a_z.jpg"
			width="640" height="426"
			alt="Evergreen Mountain Lookout Sunset by Michael Matti">
	</a>
	<figcaption>
		Evergreen Mountain Lookout Sunset by <a href="https://www.flickr.com/photos/michaelmattiphotography/">Michael Matti</a>,
		used under <a href="https://creativecommons.org/licenses/by-nc/2.0/">Creative Commons 2.0 BY-NC</a>
	</figcaption>
</figure>


Two types of code worth investing in are critical sections of your application
and where you plan on doing work in the future. If there is a high probability
you will be working on or troubleshooting code in the future do a favour for
future you and simplify it.

Every project has one part which is the most important. Typically it is the one
killer feature why you did the project in the first place. The fundamental
business logic only this project performs or the one page every user loves.
Caring for core sections of any project is worthwhile.

Important feature need to work every time. A regression in a critical tool is
awful for the user experience. Having great test coverage and simplifying the
code around your core features will help keep the code easy to maintain and
updates as requirements change.

Infamous code riddled with bugs is another good place to invest time in.
Provided you want to keep the functionality around, stabilizing a section with
higher than normal defects could help uncover even more you do not know about
yet. [Defects tend to cluster together][defect-cluster].

Adding functionality and plan to add more in the future? The amount of time you
plan on spending in an area or integrating with it is a good way to decide how
much refactoring/cleanup you want to do. Setting up for new changes is a great
reason to refactor. After you have implemented new functionality you could
consolidate the existing classes.

Unsure?
===============================================================================

<figure class="image-center">
	<a data-flickr-embed="true"
		href="https://www.flickr.com/photos/66176388@N00/5669437281/"
		title="New Leaves And Old by Mark Robinson">
		<img
			src="https://farm6.staticflickr.com/5187/5669437281_84e78ff2c0_z.jpg"
			width="640" height="427"
			alt="New Leaves And Old by Mark Robinson">
	</a>
	<figcaption>
		New Leaves And Old by <a href="https://www.flickr.com/photos/66176388@N00/">Mark Robinson</a>,
		used under <a href="https://creativecommons.org/licenses/by-nc/2.0/">Creative Commons 2.0 BY-NC</a>
	</figcaption>
</figure>

Not sure what the future holds? If the area you working in is not important or
will have only minor changes in the future it is not worth your time. It still
may be worth some effort to keep the cobwebs out.

The best thing to do if you are not sure is to play it safe and only do small
improvements. Any extensive effort may not end up being worth it. Spending a
few hours might still make sense, but days or weeks would not.

I would focus on the essential improvements: eliminating duplication and
improving the testability.

If there is some minor duplication reducing it will shrink the amount of
code you need to maintain. Start with a simple refactoring like ["Extracting a Method"][extract-method].
I recently extracted a method to provide some common logic which would
otherwise have been copied repeatedly throughout the code. Instead we had a
simple method we could reuse.

Find part of the code confusing? Not enough testing in an area? Wrapping
existing code in tests can help explain what is happening and make other
changes safer. Tests provide a safety net for future changes and can often be
added fairly easily.

Long Frozen Over
===============================================================================

<figure class="image-center">
	<a data-flickr-embed="true"
		href="https://www.flickr.com/photos/chadcooperphotos/11874715865/"
		title="Frozen Trees by Chad Cooper">
		<img
			src="https://farm3.staticflickr.com/2879/11874715865_8a2712f956_z.jpg"
			width="640" height="427"
			alt="Frozen Trees by Chad Cooper">
	</a>
	<figcaption>
		Frozen Trees by <a href="https://www.flickr.com/photos/chadcooperphotos/">Chad Cooper</a>,
		used under <a href="https://creativecommons.org/licenses/by/2.0/">Creative Commons 2.0 BY</a>
	</figcaption>
</figure>

Long forgotten code that has been left for dead should be left with minimal
changes. This code may be considered "done" and has not been touched for a long
time and you don't expect to come back. Any effort is probably wasted and it
often would be a better decision to just walk away.

No client will benefit from the work you do to this unloved code. No matter how
much you might want to restructure the classes to the perfect hierarchy it is
not worth it.

We recently declared one of our projects as dead. When we first started we wrote
a large number of tests through the UI. While great when we first started these
tests eventually feel into disrepair as we were moved to different projects. We
decided it was not worth dedicating the effort to fix all the tests right now
and instead would add new tests to eventually replace the existing code.

If you must make changes to such long done projects try to get in, make your
changes and then leave. Don't make the project worse than it is, but don't
stick around either.

Updating dead code is like shuffling deck-chairs on the Titanic. Don't you have better things to do?

Summary
===============================================================================

What improvements or refactoring will pay off the most? I don't know. It depends on you code.
Too many defects? Refactoring for testability and adding more tests could help prevent regressions or
future defects. Do you have to repeat the same changes in
multiple areas? Reducing the duplication could help you. Try browsing the
[refactoring catalog][catalog] for more ideas.

In summary, scale your effort based on how important the code is and what you
plan on doing in the area.

Refactor

* Plan on sticking around? Make an investment.
* Critical Code? Keep it clean! Be careful.

Minor Improvements

* Not sure what to do? Stay small.

Stop

* Left for dead? Leave it be.
* Do not shuffle the deck-chairs on the Titanic.

[defect-cluster]: http://www.testingexcellence.com/defect-clustering-in-software-testing/
[extract-method]: http://refactoring.com/catalog/extractMethod.html
[catalog]: http://refactoring.com/catalog/
