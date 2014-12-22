---
layout: post
title:  "Extreme Deployment As A Feature"
date:   2014-09-22 23:11:07
tags: deployment, projects
---

In discussing this with coworkers we had an interesting debate over having an
empty first release. This is an extreme but can be useful if shipping is very
hard for your company but should be uncessary in most situations. This would
mean skipping your first feature entirely and releasing just enough code to
validate the deployment and processes around the product. This is perhaps most
useful in an enterprise environment and not useful for a startup where every
minute is one step closer to extinction or outlandish riches.

An empty deployment feels wrong to me since the skeleton you ship may be very
different than the actual system. Building and releasing actual functionality
helps prove you have done just enough work on the deployment. The opposite does
not necessarily hold true and is harder to know when to stop.

You still might want to consider this extreme. It can provide practice for the
team at deploying what will become your product. It ensures that a deployment
is in place before anything else happens. Ideally the deployment would be used
within a continuous integration process and would continue to function as the
project grows and changes.