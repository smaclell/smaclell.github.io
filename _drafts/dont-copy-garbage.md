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
refactoring some more I took a confusing pattern and repeated it many times.
Although I was improving the code I was refactoring I was spreading the bad
decisions and garbage around much further than I should.

As an [Exterminator][tribute], I had been trying to tease apart one particularly
intertwined code with rampant duplication. It repeated the same 4 core methods
for different parts of the system. Each was slightly different than the
previous one.

The implementations were different enough and supporting components spread out
throughout the application we decided to add an abstraction to unify the
4 methods. This would allow us to move the implementation closer to the domain they
supported.

New interfaces were added which made each implementation more opaque. In order
to understand and follow the new code you would need to understand how the
consumer used the new interfaces. The implementations were now separate from
the consumer whereas before they were heavily intertwined.

To make matters worst some of the implementations followed a pattern which when
centralized was contained, but when copied throughout the code became confusing.
Others not familiar with the original operation would question why it might need
the extra changes. Less discerning individuals might start copying the pattern
for their code thinking it was recommended having seen it repeated by me
multiple times.

I had accidentally spread this bad design pattern. I had been so focused
on fixing the duplication in one area, I had spread it throughout the code
instead of being centralized. To make matters worst I had done it over 10
times.

In talking to my co-worker it reminded me of why I was trying to do this change
in the first place: reduce duplication. Even while I had been moving the code
from the central location to the individual domains I had thought about what I
could do to simplify it. The danger signs I was doing something wrong had been
there and I had carried on.

I think the lesson here is simple: **Don't Copy and Paste Garabage**. You could
take it as far as to say [Duplicate Code is Evil][evil]. I had taken a
contained bad thing and spread it all throughout the code. I regret doing it
and hope we both think twice before doing it again in the future.

Tomorrow I am going to fix it. I will change the interface to prevent the
questionable pattern from spreading and document why it was done. The new code
will again centralize this particular choice instead of copying and pasting it
around the code base.

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[evil]: https://hethmonster.wordpress.com/2010/09/21/duplicate-code-is-evil/