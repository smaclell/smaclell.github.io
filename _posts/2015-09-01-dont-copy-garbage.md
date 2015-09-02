---
layout: post
title:  "Don't Copy and Paste Garbage"
date:   2015-09-01 11:31:07 -4:00
tags: refactoring learning
image:
  feature: garbage.jpg
---

<!-- image source https://pixabay.com/en/m%C3%BClltonnen-garbage-disposal-594412/ -->

I was recently confronted by a coworker about some changes I had made. While
refactoring, I took a confusing pattern and repeated it many times.
Although I was improving the code I was refactoring I was spreading the bad
decisions and garbage around much further than I should.

As an [Exterminator][tribute], I had been trying to tease apart some particularly
intertwined code with rampant duplication. It repeated the same 4 core methods
for different parts of the system. This code had a lot of structural duplication
where the same operations were repeated and tweaked for the different domains.

The implementations were different enough and supporting components spread out
throughout the application we decided to add an abstraction to standardize the
4 methods. This would allow us to move the implementation closer to the domains
they supported. By moving the implementations closer to the other classes they
used it would make the implementations easier to update as the target domains
changed. This was even more attractive since many implementations used legacy
classes scattered throughout the code.

The new standardized interfaces had the side effect of making each
implementation more opaque. In order to understand and follow the new code you
would need to trace how the new interfaces were consumed. The
implementations were now separate from the consumer whereas before they were
heavily intertwined.

Even worse, some of the implementations followed a pattern which when
centralized was contained, but when moved throughout the code became confusing.
Others not familiar with the original logic would question why it might need
the odd changes. Less discerning individuals might start copying the pattern
and use it in their code thinking it was recommended having seen it repeated
multiple times.

By accident I had spread a bad design pattern. I had been so focused
on fixing the duplication in the original code; I had spread the dangerous
pattern throughout the code ruining its previous centralization. To make
matters worse I repeated the pattern it over 10 times.

In talking to my co-worker it reminded me of why I was trying to do this change
in the first place: reduce duplication. By repeating this bad code I had partially
undone some of the gains I was trying to achieve.

Even while I had been moving the code from the central location to the
individual domains, I was thinking about how to simplify the repetition in the
code I was moving. The danger signs I was doing something wrong had been there
and I carried on.

I think the lesson here is simple: **don't copy and paste garbage**. You could
take it as far as to say [Duplicate Code is Evil][evil]. I had taken a
contained bad thing and spread it all throughout the code. I regret doing it.
I hope you and I think twice before doing it again in the future.

Tomorrow I am going to fix it. I will change the interface to prevent the
questionable pattern from spreading and document why it was done. The new code
will again centralize this particular choice instead of copying and pasting it
around the code base.

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[evil]: https://hethmonster.wordpress.com/2010/09/21/duplicate-code-is-evil/