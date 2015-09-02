---
layout: post
title:  "Maintaining Code For Money"
date:   2015-04-16 00:27:57 -4:00
tags: refactoring priorities
---

Refactoring is fun. Taking code and transforming how it fits together without
breaking it can be art. Getting carried away with tweaking your code and
continuously refactoring can be a problem. Trying to clean up existing code or
add more tests is time consuming. Before you try to maintain existing code it is
really important to know whether your effort will be worth it. This post
examines different stages in the code life cycle and how they shift how much
you should invest in cleaning up the code.

I like having a job. Everyday when I go to work I am happy they let me in and
code up a storm. The important difference between my job and a really kick ass
hobby is that I get paid. We are a business and staying in business is
important for our customers, myself and my family.

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
Caring for core sections of any project is worth while.

Important feature need to work every time. A regression in a critical tool is
awful for the user experience. Having great test coverage and simplifying the
code around your core features will help keep the code easy to maintain and
updates as requirements change.

Special case: Defect Magnet!

TODO: Future investment
TODO: Changing purpose.

The best time to refactor is when you want to make an investment. You plan on
extending and revisiting the code many times in the future. If you can think
of another story in the same area it is probably worth doing some work to make
things easier.

The most obvious changes would make extensions in expected directions easier.
For example, you have a website which can convert from one format to another.
Being able to support new formats could be an upcoming feature. It would be
a good idea to make the code able to support adding new formats. This doesn't
mean doing the work to import or export another format, instead setting up the
code so it will be easier to do so later.

Alternatively, if you see duplicate code and know you are about to do the same
thing again you should consider consolidating the code.

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

Not sure? Do something small. Can you do something while you do your task? What about adding good tests or making the code testable?
More tests?

TODO: Eliminate Duplication and Testability

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

Left for Dead.
Do not shuffle the deckchairs.

Today we walked away from a refactoring. We found some tests which did not work
as expected. Instead of spending time refactoring the code and dealing with the
problem it was better worth our time elsewhere.

Summary
===============================================================================

What refactoring will pay off the most? I don't know. It depends on you code.
Too many defects? Refactoring for testablity and adding more tests could help prevent regressions or
future defects. Do you have to repeat the same changes in
multiple areas? Reducing the duplication could help you. Try browsing the
[refactoring catalog][catalog] for more ideas.

Refactor

* Plan on sticking around? Make an investment.
* Critical Code? Keep it clean! Be careful.

Minor Improvements

* Not sure what to do? Stay small.

Stop

* Left for dead? Leave it be.
* Do not shuffle the deckchairs on the Titanic.

[catalog]: http://refactoring.com/catalog/