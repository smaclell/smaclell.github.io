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

I was refactoring some code which had some unusual data access. It used a key
value store to save simple data and then later retrieve it. Values were saved
separately for different users. We decided to change the key value store to use
give all users the same value. Logically, the value should be the same for
anyone using the system.

I thought I could take a shortcut. Since the values would be identical for all
users then why not use a singleton to store the value. We could remove the key
value store completely and be much simpler. Or so I thought.

TODO: Picture of before/after

Intervention
===============================================================================

Single point of failure
By definition singletons can create a single point of failure.

Cannot scale out any more

Optimization

Not the Tool for the Job
===============================================================================

Generally bad. Try using other patterns or coordination to do what you want.