---
layout: post
title:  "Investing in your Code"
date:   2015-09-10 23:39:07 -4:00
tags: refactoring maintenance priorities
---

Taking code and transforming how it fits together without breaking it is an
art. It is also great fun! However, before you start I think you should
understand whether your efforts will be worthwhile. This post examines
different stages in the code life cycle and how they affect how much
you should invest in cleaning up code.

I like having a job. Every day when I go to work I am happy they let me in so I can
code up a storm. The important difference between my job and a really kick ass
hobby is getting paid. We are a business and staying in business is
important for me and our customers.

Taking the time to make deep changes is a good thing. The larger the impact of
the change the more important it is to understand why it will be valuable in the long term.
What will the impact be? How will the change help your users?

When it comes to refactoring and maintaining code I think this especially tricky. The more entangled
the code is the more I want to "fix" it. Beautiful code is something to be
admired and even pursued, but only as a means to an end. At the end of the day
you still have to ship and support your product.

I think it is important to think about when to update code, how much to
change and what the long term benefit will be of what you are doing. Balancing
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


Three categories of code are worth investing: your application's critical sections,
defect filled areas
and where you plan on doing work in the future. These categories often overlap and
cause the code to be more important. There is a higher probability
you will be working on or troubleshooting these areas in the future. Do a favour for
future you and leave the code better than you found it.

Every project has features which are more important. Often this will be the
reason why the project was started in the first place. The fundamental
business process only this project performs or the one page every user loves.
Caring for core sections of any project is worthwhile.

Important feature need to work every time. A regression in a critical tool is
awful for the user experience. Having great test coverage and simplifying the
code around your core features will help keep the code easy to maintain and
updates as requirements change.

Larger refactoring exercises are reasonable since improvements will have a bigger
impact for your users. Organic growth and tacked on features can lead to areas
which do not fully make sense. Restructuring classes to better align and
simplify how they interact is justified. In the critical section it is more
important to prevent causing issues with your changes. Be careful.

Infamous code riddled with bugs is another good place to invest time in.
This is another critical section for all the wrong reasons. The attention it
gets is bad and your users will start to notice repeat issues.
[Defects tend to cluster together][defect-cluster] and cleaning up the whole area can be a good approach. Reducing complexity
which leads to more defects is even better. However, if you don't plan on
supporting the functionality despite the defects this is dead code in disguise and you should move on.

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
only needs minor changes then spending lots of time cleaning it up is not as
useful. Spending a few hours might still make sense, but days or weeks would not.
The key is balancing how much time and effort you spend doing it.

What is the best thing to do if you are not sure about how much or what
maintenance would be good? Play it safe and focus on smaller improvements.
I would focus on the essential improvements: eliminating duplication and
improving the testability.

Reducing duplication shrinks the amount of code you need to maintain. Starting
with a simple refactoring like ["Extracting a Method"][extract-method] is a
good start. I recently extracted a method to encapsulate logic which
had been copied repeatedly. Now there is one place to fix
maintain instead of the many copies.

Find part of the code confusing? Afraid to make changes in an area? Wrapping
existing code in tests can help explain what is happening and make other
changes safer. Tests provide a safety net for future changes and can often be
added fairly easily. Refactoring to make code testable will help loosen heavily
coupled classes.

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

Long forgotten code that has been left for dead should be avoided. It is okay for code to be "done" and not
expect to change in the future. Any effort is probably wasted or much harder
than it needs to be. Often it would be a better decision to walk away.

Clients will see little benefit from the work you do to this unloved code. No matter how
much you might want to restructure the classes to perfectly separate concerns it is
not worth it.

We recently declared one of our projects as dead. When we first started we wrote
a large number of tests through the UI. The tests were great when we first created them,
but eventually fell into disrepair as we moved onto other projects. We
decided it was not worth dedicating the effort to fix all the tests right now
and instead we would add new tests to eventually replace the existing code.
For us it would be better to rewrite or remove the tests than maintain them.

If you must update one of these forgotten relics; get in and get out.
Don't make the project worse than it is, but don't stick around either.
Updating dead code is like shuffling deck-chairs on the Titanic.
Don't you have better things to do with your time?

Summary
===============================================================================

Before you dive in think about what areas or projects would benefit the most
from your improvements. What changes will pay off of the most?

Too many defects? Refactoring for testability and adding more tests could
help prevent future defects. Are you repeating the same
changes in multiple areas? Reducing duplication could help you. Try
browsing the [refactoring catalog][catalog] for more ideas.

The answer will depend on your projects and time-lines. I hope this gave you
some new ways to think about when to invest and when to back off.

In summary, I recommend scaling your efforts based on how important the code is and what you
plan on doing in the area.

**Invest**

* Critical Code? Keep it clean!
* Bugs abound? Squash them down.
* Plan on sticking around? Make an investment.

**Minor Improvements**

* Not sure what to do? Stay small.
* Focus on the essentials: Reduce duplication and better tests.

**Stop**

* Left for dead? Leave it be.
* Do not shuffle the deck-chairs on the Titanic.

[defect-cluster]: http://www.testingexcellence.com/defect-clustering-in-software-testing/
[extract-method]: http://refactoring.com/catalog/extractMethod.html
[catalog]: http://refactoring.com/catalog/
