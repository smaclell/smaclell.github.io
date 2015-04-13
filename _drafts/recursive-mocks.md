---
layout: post
title:  "Moq Minute - Recursive Mocks"
date:   2015-03-30 00:09:07
tags: moq moq-minute testing
---

I love Moq, it is the essential mocking library for .NET. This week I learnt
a new feature for simplifying your mock setup: Recusive Mocks.

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
I hope you like this Moq feature and try it out soon. Enjoy.

<hr />

I wanted to share this with my co-workers and decided sharing it here would be
an even better way to [save keystrokes][keystrokes].

[keystrokes]: http://blog.jonudell.net/2007/04/10/too-busy-to-blog-count-your-keystrokes/
