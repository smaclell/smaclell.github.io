---
layout: post
title:  "Fixing Problems Is Better Together"
date:   2015-08-20 00:02:07 -4:00
tags: devops collaboration stephen
image:
  feature: two-guys.jpg
  credit: Gibson Street, Bowden by Gary Sauer-Thompson CC BY NC 2.0 (resized and compressed)
  creditlink: https://www.flickr.com/photos/sauer-thompson/8299729886/
---

Last week, a co-worker and I made a very interesting discovery. We found an
easy performance improvement we could make right away. It took less than a
day to make a fix which will hopefully have a big impact. Working together made
it possible for us to find and fix this issue so quickly. I want to tell you
our story.

My coworker, Stephen, has data. Lots of it! He loves it. He has been collecting
many metrics from our production clients and patiently storing them. With this
data he can deftly find interesting trends and answer many questions.

Unlike Stephen, I don't have access to production. I am okay at looking at data
using excel, but that is about it. While I have access to some rudimentary
telemetry data, I am only starting to learn how to dig deeper into it.

Stephen is not a developer. I love develop software and fixing problems. We each
have a perspective and knowledge the other lacks. Where Stephen has data, I have
code. Together we can find and solve problems better and faster.

Finding Something Interesting
===============================================================================

Recently, we were looking at logs for web requests together. We want to better understand
the system and find areas for improvement. There are many different ways to look
at the data and we decided to normalize our request urls then look at aggregates.
By removing identifiers for each request we were able to normalize the urls so
that we could better group together similar requests. We then determined the total
number of requests each url received and the number of unique users who viewed each url.

We quickly found an outlier which was had many requests from both of our metrics.
The ratio between the two metrics also showed that users often performed the request
many times and that it was very popular amongst our users.

We then dug a little deeper to understand exactly why this request occurred.
The request is used on many pages to and would poll the servers to get updated
values. This explained why the request was so popular. Due to the polling the
request would be run very frequently as users navigate throughout our system.

Taking Action
===============================================================================

Armed with the data from Stephen we knew we needed to improve this request.
The number of times it was called was too high.

Due to data from the polling the request is only valuable to users viewing the system. We realized if the user
left the page or switched tabs we can stop polling the server for updates.
Continuing to check for updates is unnecessary if the user will never see them.
Once the user comes back to the page we can then run the request immediately
to update the UI.

Enter the [Page Visibility API][pv]. Almost all browsers now support a native
API which allows us to do exactly what we wanted. We can stop polling based on
the ``visibilitychange`` event and start again when the user returns.

Within an afternoon I was able to make an update using the Page Visibility API
which would stop polling when the user could not see the page. This was a very
simple fix to reduce the number of times the polling occurs.

I had also considered allowing the browser to cache the request and
polling less frequently. We decided against both options for
now to better preserve the existing user experience. With the current change users
should not even notice the difference in behaviour.

Watching the Change
===============================================================================

It will be a little while before my fix is in production. When it is released
into the wild, Stephen and I will be able to track how effective the change is
at reducing the number of requests.

It is not guaranteed to make the results better.  Depending on user traffic
the savings might be higher or lower. How often are we in a background tab?
Do users minimize their browsers when they are not using our site? We know roughly
what the best possible savings could be and if we are even a fraction of that
number our effort would still be worthwhile.

I hope by closely watching how the change does we can iterate on it or use this
as motivation to explore other changes. If the change turns out to not be a big
improvement then we can revisit extra caching or less frequent polling.

DevOps, More than a Buzzword
===============================================================================

I intentionally avoid using the term DevOps at work. It means very different
things to different people to the point where it starts to lose meaning. Using
it is similar to sending manager into a tizzy when you ask them to define the
cloud.

Instead, I try to focus on the behaviours from DevOps I think are game
changers. Let's work together on this. If would had more data we could make
better decisions. What is hard for you? We could automate that together!

In this case, Stephen and I, collaborated together to do something we could not
do alone. We focused on better understanding the metrics we were collecting so
we could action them. While we might represent two different worlds, we are
both working toward making our product and operations better. When you embody
DevOps behaviours good things happen.

Better Together
===============================================================================

Working with Stephen and improving this request was fun! Finding and fixing a
request like this would be much harder if we were not doing it together. The
effort to notify another group and prioritize the work would have been
longer than it took for us to find the problem and try to fix it. Our
two perspectives allowed us to quickly find the problem and implement a
potential solution with very little overhead.

I think having people with different skills and perspectives working together is
fantastic. Seeing Stephen's operational data provides completely new
opportunities to explore. I am looking forward to doing more!

If you are a developer and have not had the privilege of working with the
people who operate the software you are building, I think it is time you went
and made a new friend.

[pv]: https://developer.mozilla.org/en-US/docs/Web/Guide/User_experience/Using_the_Page_Visibility_API
