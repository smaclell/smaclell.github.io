---
layout: post
title:  "Moq Minute -  Linq to Moq"
date:   2015-03-30 00:09:07
tags: moq moq-minute testing
---

I love Moq, it is the essential mocking library for .NET. This week I learnt
two new features for simplifying your mock setup: Recusive Mocks and Linq to
Mocks.

**Recursive Mocks**

Needing to have mocks return mocks is a hassle. Prior to learning about this
feature my mocks would looks something like this:

{% highlight csharp %}
using Moq;

Mock<Bar> bar = new Mock<Bar>();
bar.Setup( x => x.Run() ).Returns( "baz" );

Mock<Foo> foo = new Mock<Foo>();
foo.Setup( x => x.Bar ).Returns( bar );
{% endhighlight %}

It feels gross. I needed to setup a completely different mock so I could return
it later. With recursive mocks you can setup mocked properties automatically.
Here is the same code using recursive mocks:

{% highlight csharp %}
using Moq;

Mock<Foo> foo = new Mock<Foo>();
foo.Setup( x => x.Bar.Run() ).Returns( "baz" );
{% endhighlight %}

Much simpler. It can also be used for methods and I imagine other areas too.

**Linq to Mocks**

This feature lets you use a Linq like syntax to setup mocks. This is great for
really simple mocks. I first started using them as an alternative way to create
mocks where I did not care how they were used. Previously I declared a complete
mock, but with the new syntax can be much simpler:

{% highlight csharp %}
using Moq;
using System.Data;

IProgress<int> original = new Mock<IProgress<int>>().Object;

IProgress<int> updated = Mock.Of<IProgress<int>>();
{% endhighlight %}

Later a coworker showed me you could setup basic behaviours easily!
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

This can take some getting used to and looks wonky at first, but for really
simple situations I think this will simplify my test setup.

**Summary**

I hope you liked these Moq features for simplifying your test setup. Enjoy.

<hr />

I wanted to share this with my co-workers and decided sharing it here would be
an even better way to [save keystrokes][keystrokes].

[keystrokes]: http://blog.jonudell.net/2007/04/10/too-busy-to-blog-count-your-keystrokes/
