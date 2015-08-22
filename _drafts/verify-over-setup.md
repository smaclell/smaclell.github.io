---
layout: post
title:  "Moq Minute - Verify over Setup"
date:   2015-08-19 00:27:57 -4:00
tags: moq moq-minute testing jeff
---

I love Moq. I think it is the best .NET mocking library. For a long time I have
been using Verify to ensure the correct behaviour instead of using a strict Setup.

When I first started mocking, I often had very complicated setup for each mock
with the exact signature I expected. Another bad habit was making the mocks
``Verifiable`` so I could easily know if they were called. Both cases make the
tests and code more brittle. Overall these tests and mocks were painful.

{% highlight csharp %}
Mock<IExample> mock = new Mock<IExample>( MockBehavior.Strict );
mock.Setup( m => m.Run( 7 ) );

IExample target = mock.Object;

target.Run( 7 );
{% endhighlight %}

Now I use looser mocks and verify only the interactions I care about:

{% highlight csharp %}
Mock<IExample> mock = new Mock<IExample>();

IExample target = mock.Object;

target.Run( 7 );

mock.Verify( m => m.Run( 7 ) );
{% endhighlight %}

The looser mocks make the code less fragile. By being more accepting of
different cases the mocks can allow more potential implementations. In most
cases the extra strictness is not required and gets in the way.

The test clearly separates the setup from the assertions as recommend by
[AAA][aaa]. You can see exactly what is expected in the assertions instead of
doing everything in the setup.

When a test fails the verification pinpoints exactly why. My previous style,
using ``Setup``, would instead throw a weird exception when the method is
called or list of one many verifiable methods which were not called as expected.

<hr />

Try it out! See if you like explicitly verifying methods you expect to be
called. My mocks are much looser and I only verify the calls I care about.

<hr />

*I would like to thank my former coworker, [Jeff][jeff], who first showed me
this approach and why it was better.*

[aaa]: http://c2.com/cgi/wiki?ArrangeActAssert
[jeff]: http://www.beyondtechnicallycorrect.com/
