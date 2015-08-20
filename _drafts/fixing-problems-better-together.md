---
layout: post
title:  "Fixing Problems Is Better Together"
date:   2015-08-19 00:27:57 -4:00
tags: devops collaboration stephen
image:
  feature: two-guys.jpg
  credit: Gibson Street, Bowden by Gary Sauer-Thompson CC BY NC 2.0 (resized and compressed)
  creditlink: https://www.flickr.com/photos/sauer-thompson/8299729886/
---

Last week, a co-worker and I made a very interesting discovery. We found a very
easy performance improvement I was able to make right away. It took less than a
day to make a fix which will hopefully have a big impact. There are few key
things which came together to make this fix possible. I want to tell you why we
are better when working together.

My coworker, Stephen, has data. Lots of it! He loves it. He has been collecting
many metrics for our production clients and patiently storing them. With this
data he can deftly find interesting trends and answer many questions.

Unlike Stephen, I don't have access to production. I am okay at looking at data
using excel, but that is about it. While I have access to some rudimentary
telemetry data, I am only starting to learn how to dig deeper into it.

Stephen is not a developer. I cannot spend enough time developing. We each have
a perspective and knowledge the other lacks. Where Stephen has data, I can
creatively change our product.

Finding Something Interesting
===============================================================================

Together we were looking at logs for web requests. We want to better understand
the system and find areas for improvement. There are may different ways to look
at the data and we decided to review aggregates of our normalized requests. I
say normalized requests because we removed any identifiers from the urls so we
have fewer unique requests. We then determine the total number of requests each
url received and the number of unique users who viewed each url.

We quickly found an outlier which was much more active than we expected. This
one request had lots of total requests and unique requests by users. The ratio
between the two also showed us users often performed the request and many users
would perform the request.

We then dug a little deeper to understand exactly how this request occurred.
The sample request is used on many pages and would poll the servers to get updated
values. For any given user session this this request could be issued many times
resulting in it being a very popular page.

Taking Action
===============================================================================

Armed with the new data from Stephen we knew we needed to improve this request.
The number of times it was called was too high.

The request is only valuable to users viewing the page. We realized if the user
left the page or switched tabs we can stop polling the server for updates.
Continuing to check for updates is unnecessary if the user will never see them.
Once the user comes back to the page we can then run the request immediately
to update their UI.

Enter the [Page Visibility API][pv]. Almost all browsers now support a native
API which allows us to do exactly what we wanted. We can stop polling based on
the ``visibilitychange`` event and start again when the user returns.

Within an afternoon I was able to make an update using the Page Visibility API
which would stop polling when the user could not see the page.

I had also considered allowing the browser to cache the result of the request.
Another option was to poll less frequently. We decided against both options for
now to preserve the existing user experience. With the current change users
should not even notice the difference in behaviour.

Watching the Change
===============================================================================

It will be a little while before my fix is in production. When it is released
into the wild, Stephen and I will be able to track how effective the change is
at reducing the number of requests.

It is not guaranteed to make the results better.  Depending on how our system
is used the savings might be higher or lower. Is it often opened in a
background tab? Do users minimize it if they are not using it? We know roughly
what the best possible savings could be and if we are even a fraction of that
number our effort would still be worthwhile.

I hope by closely watching how the change does we can iterate more or use this
as motivation to explore other changes. If the results are not where we would
like them to be then maybe extra caching or less frequent polling will be
necessary.

Better Together
===============================================================================

Working with Stephen and improving this request was fun! Finding and fixing a
request like this would be much harder if we were not doing it together. Our
two perspectives allows us to quickly find the problem and implement a
potential solution.

I think having people with different skills and perspectives work together is
fantastic. Seeing Stephen's operational data provides completely new
opportunities to explore. I am looking forward to doing more!

If you are a developer and have not had the privilege of working with the
people who operate the software you are building, I think it is time you went
and made a new friend.

<hr />

I intentionally avoid using the term DevOps at work. It means very different
things to different people to the point where it starts to lose meaning. Using
it is similar to sending manager into a tizzy when you ask them to define the
cloud.

Instead, I try to focus on the behaviours from DevOps I think are game
changers. Lets work together on this. If would had more data we could make
better decisions. What is hard for you? We could automate that together!

[pv]: https://developer.mozilla.org/en-US/docs/Web/Guide/User_experience/Using_the_Page_Visibility_API
