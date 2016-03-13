---
layout: post
title:  "Keep the mud on the edges"
description: "How we now setup our PowerShell projects to keep them easy to maintain."
date:   2015-12-30 23:45:07
tags: powershell conventions maintenance
image:
  feature: https://farm8.staticflickr.com/7528/15037595713_077b784de6_b.jpg
  credit: "The artist by Shawn Harquail - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/harquail/15037595713/
---

We don't like our code anymore. It started with some simple ideas, but over time
has become a big ball of mud. Data is tossed around and modified all over the
place. The rules for how they system works are complicated. At one point we
copied a bunch of the code support similar scenario. In this post I am going
to explain how we got here and what I think we need to do in order to get out
of this mess.



Keep your mud at the edges

Read Files
Transform Them <- Brutal
Combine Them With Data
Output Values

The transform is used much too often throughout the application
All them mangling is hard to follow.

Originally:

From Daryl

There are many interconnected pieces interacting within the InstanceTransformers (further complicated by AWS). If you follow how the data is used it is barely changed for half the data and horribly bounced around for server data.

We should push the data to the edge right before it is sent out. Limit the number of places which need to care about the data and simplify the process.

servers = GetServers()