---
layout: post
title:  "Moq Minute - Linq to Moq"
date:   2015-03-30 00:09:07
tags: moq moq-minute testing
---

I love Moq. I think it is the best .NET mocking library. This week I learnt
a new feature for simplifying your mock setup: **Linq to Mocks**.

This feature lets you use Linq like syntax to setup mocks. This is great for
really simple mocks. I first started using them as an alternative way to create
mocks where I did not care how they were used. Previously I declared a complete
mock, but with the new syntax can be much simpler:

{% highlight csharp %}
using Moq;
using System;

IProgress<int> before = new Mock<IProgress<int>>().Object;

IProgress<int> after = Mock.Of<IProgress<int>>();
{% endhighlight %}

Later, a coworker showed me you could setup basic behaviours easily!
Using a lambda expression you can specify the method to be called, any
constraints on parameters and the return value. In the sample below the method
``ExecuteScalar`` can be called to return ``"return value"``. Neat eh?

{% highlight csharp %}
using Moq;
using System.Data;

IDbCommand command = Mock.Of<IDbCommand>(
	x => x.ExecuteScalar() == "return value"
);
{% endhighlight %}

The syntax can take some getting used to and looks wonky at first, but for really
simple mocks helps simplify your test setup.

I hope you like this Moq feature and try it out soon. Enjoy.

<hr />

I wanted to share this with my co-workers and decided sharing it here would be
an even better way to [save keystrokes][keystrokes].

[keystrokes]: http://blog.jonudell.net/2007/04/10/too-busy-to-blog-count-your-keystrokes/
