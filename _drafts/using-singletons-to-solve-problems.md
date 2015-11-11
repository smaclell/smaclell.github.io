---
layout: post
title:  "Using Singletons To Solve Problems Is Wrong"
date:   2015-11-16 22:37:07
tags: design-patterns design daryl
---

The Singleton pattern is normally not what you want to use. It is great for
optimizing creating instances, but otherwise has limited utility. Recently, I
had a problem where I briefly considered using a singleton to deal with it.
Using a singleton to solve problems is wrong and leads to more problems.

Your problem.

Single point of failure

Cannot scale out any more

Optimization

Generally bad. Try using other patterns or coordination to do what you want.