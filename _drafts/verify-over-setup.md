---
layout: post
title:  "Moq Minute - Verify over Setup"
date:   2015-08-19 00:27:57 -4:00
tags: moq moq-minute testing jeff
---

I love Moq. I think it is the best .NET mocking library. For a long time I have
been using Verify to ensure the correct behaviour instead of using a Setup.

For our mocking fun we are going to use the following interface:

{% highlight csharp %}
interface IExample {
    void Run( int value );
}
{% endhighlight %}

When I first started out using mocking, I often had very complicated setup for
each mock. I would often setup the exact method signature to be called. Another
common anti pattern was heavily using ``Verifiable`` mocks with an explicit
setup. Both cases led to brittle tests where changing either the code or
the tests was painful.

{% highlight csharp %}
Mock<IExample> target = new Mock<IExample>( MockBehavior.Strict );
target.Setup( m => m.Run( 7 ) );

IExample test = target.Object;

test.Run( 7 );
{% endhighlight %}

Now I use looser mocks and verify only the interactions I care about. Looser
mocks make the code less fragile.

Now most of my tests with mocks look like this:

{% highlight csharp %}
Mock<IExample> target = new Mock<IExample>();

IExample test = target.Object;

test.Run( 7 );

target.Verify( m => m.Run( 7 ) );
{% endhighlight %}

The test clearly separates the setup from the assertions as recommend by
[AAA][aaa]. You can see exactly what is expected in the assertions instead of
blending what is expected with the setup.

When a test fails the verification pinpoints exactly why. My previous style,
using ``Setup``, would instead throw a weird exception when the method is
called or list of one many method which were verifiable but not called.

Try it out! See if you like explicitly verifying methods you expect to be
called. My mocks are much looser now and I only verify the calls I care about.

<hr />

*I would like to thank my former coworker, [Jeff][jeff], who first showed me
this approach and why it was better.*

[aaa]: http://c2.com/cgi/wiki?ArrangeActAssert
[jeff]: http://www.beyondtechnicallycorrect.com/
