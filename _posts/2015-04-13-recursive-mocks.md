---
layout: post
title:  "Moq Minute - Recursive Mocks"
date:   2015-04-13 23:43:27
tags: moq moq-minute testing
---

I love Moq. I think it is the best .NET mocking library. This week I learnt
a new feature for simplifying your mock setup: **Recursive Mocks**.

Needing to have mocks return mocks can be a hassle. Prior to learning about this
feature my mocks would looks something like this:

{% highlight csharp %}
using Moq;

Mock<Bar> bar = new Mock<Bar>();
bar.Setup( x => x.Example() ).Returns( "baz" );

Mock<Foo> foo = new Mock<Foo>();
foo.Setup( x => x.Bar ).Returns( bar );
{% endhighlight %}

This feels gross. I needed to setup multiple mocks separately which feels like
extra work. It is.

Recursive mocks allow you to setup mocked properties automatically. You can
setup methods and properties on any property of a ``Mock<T>`` without
creating a separate ``Mock<T>``.

Here is the same setup as above using recursive mocks:

{% highlight csharp %}
using Moq;

Mock<Foo> foo = new Mock<Foo>();
foo.Setup( x => x.Bar.Example() ).Returns( "baz" );
{% endhighlight %}

Much simpler. According to the [documentation][moq], it can also be used for
methods and anywhere else where a value that can be mocked is returned.

I hope you like this Moq feature and try it out soon. Enjoy.

<hr />

I wanted to share this with my co-workers and decided sharing it here would be
an even better way to [save keystrokes][keystrokes].

[keystrokes]: http://blog.jonudell.net/2007/04/10/too-busy-to-blog-count-your-keystrokes/
[moq]: https://github.com/Moq/moq4/wiki/Quickstart#customizing-mock-behavior
