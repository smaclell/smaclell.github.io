---
layout: post
title:  "Safe Ordering For Breaking Changes"
date:   2015-10-26 23:35:07
tags: versioning services api
---

When you decide to make
breaking changes to your API there is a safe easy order to follow. If you
don't you will make consumers of your API very sad. In this post I am going to
explain how we update our APIs and slowly introduce changes which
otherwise would horribly break them.

You have Version 1.0 live. It is great and you love it! Everyone is using it and
telling all their friends about it.

{% highlight bash %}
curl http://yourservice.com/api/v1.0/route \
  -X POST --data "<data />" \
  -H "Content-Type: text/xml"
{% endhighlight %}

Time goes on and all is well. Out of the blue you have an epiphany. A change to
the API which is soooo much better than Version 1.0. JSON instead of XML. You could replace the old
API in place, but it would be a breaking change which would hurt all those
users of your API.

{% highlight bash %}
curl http://yourservice.com/api/v2.0/route \
  -X POST --data "{ 'data': 'booya' }" \
  -H "Content-Type: application/json"
{% endhighlight %}

This will be okay. Take a deep breath. Begin your changes in this order:

1. Update the service to support both Version 1.0 and 2.0
2. Update all the clients to use Version 2.0
3. Remove support for Version 1.0

<figure>
	<img
		title="Its as easy as 1, 2 and 3"
		alt="The sequence of updates below"
		src="{{ site.url }}/images/safe-versionning.jpg" />
</figure>

The key to this is step 1. By having both versions live at the same time users
can switch to Version B at their leisure. This is key. They are not forced
to immediately update all their clients to take the new version. Although Version 2.0 breaks Version 1.0,
temporarily supporting both makes the change safe for all the clients.

Steps 2 and 3 can happen as quickly or slowly as you would like. I like to
accelerate the process to reduce the number of supported versions in the wild.
We have also left older versions alive for extended periods provided the cost
of supporting them was very low.

So there you have it, a nice simple order to make breaking changes to your API
without breaking your API.
