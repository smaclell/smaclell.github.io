---
layout: post
title:  "Moq Minute - Verify over Setup"
date:   2015-08-19 00:27:57 -4:00
tags: moq moq-minute testing jeff
---

I love Moq. I think it is the best .NET mocking library. I prefer using Verify
to ensure the correct behaviour instead of using a strict Setup.

When I started mocking, the setup for each mock often mirrored the exact
method calls I expected. Another bad habit was heavily using
``Verifiable`` mocks to validate the right methods were called. Both practices made my
tests and code more brittle.

{% highlight csharp linenos %}
Mock<IExample> mock = new Mock<IExample>( MockBehavior.Strict );
mock.Setup( m => m.Run( 7 ) );

IExample target = mock.Object;

target.Run( 7 );
{% endhighlight %}

Instead, I have switched to using looser mocks and verifying only important methods:

{% highlight csharp linenos %}
Mock<IExample> mock = new Mock<IExample>();

IExample target = mock.Object;

target.Run( 7 );

mock.Verify( m => m.Run( 7 ) );
{% endhighlight %}

The big difference is line 7 from the second sample, compared to line 2 from
the first sample. This subtle change shifts when the mocked behaviour is
validated to the ``Verify`` statement instead of when the mocked method is
called by the code you are testing.

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

Now when I used mocking in tests the mocks are much looser and I only verify
the calls I care about. Try it out and see if you like this style too!

<hr />

*I would like to thank my former coworker, [Jeff][jeff], who first showed me
this approach and why it was better.*

[aaa]: http://c2.com/cgi/wiki?ArrangeActAssert
[jeff]: http://www.beyondtechnicallycorrect.com/
