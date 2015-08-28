---
layout: post
title:  "Refactoring For Money"
date:   2015-04-16 00:27:57 -4:00
tags: refactoring priorities
---

Refactoring is fun. Taking code and transforming how it fits together without
breaking it can be art. Getting carried away with tweaking your code and
continuously refactoring can be a problem. Before you refactor it is really
important to know whether it will be worth it.

I like having a job. Everyday when I go to work I am happy they let me in and
code up a storm. The important difference between my job and a really kick ass
hobby is that I get paid. We are a business and staying in business is pretty
important for our customers, myself and my family.

Going deep on a technical problem or change you are making is great. The deeper
you get the more important it is to understand why you are making the change.
How will it help your users.

When it comes to refactoring I think this especially tricky. The more entrenched
the code is the more I want to "fix" it. Beautiful code is something to be
admired and even pursued, but only as a means to an end. At the end of the day
you still have to ship.

I think it is important to think about when you should refactor, how much to
change and what the long term benefit will be of what you are doing. You are
after all paid to think and solve problems.

TODO: Definition of Refactoring?

A New Dawn
===============================================================================

https://www.flickr.com/photos/michaelmattiphotography/9448609846/in/photolist-foWAwj-9f4PBx-7ZYE8w-p7JC6g-5RkeYm-dm9cxv-7ZYfa5-gm1Pi3-9PEzFv-s3cVSB-5vMRPX-eWCLWD-oBqYQJ-7byt5o-ip5SgA-8NfZFP-8NpdNn-2T1Q4F-qqKQUY-9yGeXN-fo3rhX-7xxS1c-2zZxG-dYyHCX-6Btgbp-odWyyz-pWwUZt-dwQ1Go-9SS7m4-unraMJ-82938p-D5dJV-e5n6Ur-vjP464-obq3C9-s7Pybk-gYGMp6-gBEWPZ-8DDLvX-p7FYy7-mkeRCx-nUFrAm-sa4JKN-i4jx2p-kJxeJ1-pv6i4t-orbM86-bBYMhg-6r2rVb-jhjiiW

Two types of code worth investing in are critical sections of your application
and where you plan on doing work in the future. If there is a high probability
you will be working on or troubleshooting code in the future do a favour for
future you and simplify it.

TODO: Critical Code

Every project has critical code. Maybe it is a high performance calculation or
the one page every user loves. Maintaining the most important parts of your
system is valuable.

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

https://www.flickr.com/photos/66176388@N00/5669437281/in/photolist-9CZmbD-6sfMys-RBpVC-7VVp4v-qBLxSB-8scZX-HKBX-rGFPdD-da62Wk-9x9N1Z-e948z7-6LyMTm-6HfekA-nSHuEN-oFCCHn-qeqqbC-fpA3SM-sHMA98-eChFaT-m8bJ5n-nXV6dX-5ztuut-dU9BXB-7oZNTy-efWye-so1ges-dB2G4N-aXP24T-42P5mv-dZKcut-mZ6cA6-mZ7XYo-mZ67v8-mZ7UmJ-mnoisk-51nHtJ-8SQJQ4-rWRj6W-biqGBe-qv6MgY-dU9C5k-4JDAZG-4HNgsN-5Dh2x-4buknu-4buk1o-nFPq7M-bYERKs-kTKKUJ-6fWqvX

Not sure? Do something small. Can you do something while you do your task? What about adding good tests or making the code testable?
More tests?

TODO: Eliminate Duplication and Testability

Long Frozen Over
===============================================================================

https://www.flickr.com/photos/chadcooperphotos/11874715865/in/photolist-j6k2jr-pdJjwJ-rFtC5Z-dANGQr-dw36ez-jovb59-7ofMcb-7tiTP8-7tiTDn-97aKiP-5NSGgR-dUMLJJ-9QtbKN-q4fmTc-i6hRoY-3Vtzwv-kDc8gR-4d5QmE-e2FH9t-rtfteq-93qNLE-8Y1ms6-hUMQWn-dqAaj1-83caBd-49eeGq-7unpkE-dAN3sx-jycTSJ-q5QxQA-777FW7-q9JXDZ-jDd5zM-jbunYA-oTqi2i-bVMbR8-bsFWwZ-5RRLdC-4fy4YC-5ZdfLW-7u5iVk-zUmTE-4mnCcD-8394Fi-pk6uCY-dTyjBc-aUocrV-83962x-dPaGz9-9f8fgD

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