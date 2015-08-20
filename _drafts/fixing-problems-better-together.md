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

TODO: Thoughts
We are working together. Both of us contributed to the solution. Metrics together. Solution right away. Connecting the right people.

Finding Something Interesting
===============================================================================

Together we were looking at logs for web requests. We want to better understand
the system and find areas for improvement. There are may different ways to look
at the data and we decided to use TODO:X. We quickly found an outlier which was much
more active than we expected.

This one request is used on many pages and would TODO:Y to get updated values. For
any given user session this would be a very popular page.

Taking Action
===============================================================================

Armed with the new data from Stephen we knew we needed to improve this request.

The request is only valuable to users viewing the page. If they navigate away
or switch tabs we can stop making the request. Enter TODO:Z API. Within an
afternoon I was able to make an update which should dramatically reduce the
number of requests.

Watching the Change
===============================================================================

It will be a little while before my fix is in production. When it is released
into the wild, Stephen and I will be able to track how effective the change is
at reducing the number of requests.

It is not guaranteed to make the results better. Based on the change using TODO:T
the improvements depend heavily on user behaviour. We have estimated the maximum
possible savings and even at very low savings this change can still have a big
impact.

I hope by closely watching how the change does we can iterate more or use this
as motivation to explore other changes.

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
