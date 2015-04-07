---
layout: post
title:  "Exterminators Week 3 - On Comments"
date:   2015-04-07 00:11:07
tags: code quality exterminator comments
---

Comments can be a great way to learn about new code and document unintuitive
behaviour. Good comments succinctly explain why code was done a certain way and
are kept up to date.

This week I have found myself adding more comments to code than ever before.
I think this is partially due to the code I am in and part of trying to understand it.
Improving the comments is also part of the culture on the [Exterminator][tribute] team.
As
the team works and they try to leave the documentation better than they found it.
Adding to the comments what you have learned is part of every code review.

The team tries to add comments to any code they touch to document the unusual behaviour
they are seeing. For every weird bug we solve, we can save the next person who
reads the code time understanding why it works the way it does. Together, we
have been able to slowly grow the documentation and tests along with the
changes we are making, leaving the updated code better than we found it.

In the past I have tried to rely solely on unit tests or naming to describe
my code. This works great for new code where it is easy to understand how
different classes are connected. In [legacy code][legacy] where there are
no tests and the behaviour is unclear, relying only on naming and relationships
is not enough. Good comments and meaningful names can make previously
unintelligible code usable again.

With such emphasis on comments and documentation it has got me thinking: <br/>
**What makes a good comment?**

The Unobvious/Why Behind The Code
===============================================================================

Without recreating the thinking from the original developer, it
can be impossible to know why code has been written a specific way. This is why
it is important for comments to explain concepts and connections that are not
obvious.

Take this wild code found in the Quake III source code for example:

<figure>
{% highlight c %}
float Q_rsqrt( float number )
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;

    x2 = number * 0.5F;
    y  = number;
    i  = * ( long * ) &y;                     // evil floating point bit hacking
    i  = 0x5f3759df - ( i >> 1 );             // wtf?
    y  = * ( float * ) &i;
    y  = y * ( threehalfs - ( x2 * y * y ) ); // 1st iteration
//  y  = y * ( threehalfs - ( x2 * y * y ) ); // 2nd iteration, this can be removed

    return y;
}
{% endhighlight %}
<figcaption>The source code from <a href="http://en.wikipedia.org/wiki/Fast_inverse_square_root">Wikipedia</a> (edited to be family friendly and line up more)</figcaption>
</figure>

It computes the inverse square root using a Newton-Raphson approximation. Crazy
bit magic is used to perform the computation as an integer instead of floating
point for pure speed. The resulting code was ~4 times faster using the hardware
of the day (i.e. before dedicated SSE instructions). This speed boost would be
critical for the high performance needed by the game engines it was used in. This code has
[interesting][history-1] [history][history-2] tracing the potential
authors, how it was implemented and has been widely talked about.

Despite the minor comments, this code is not intuitive for mere mortals. Gary
Tarolli, one of the developers involved and 3D graphics pioneer, also had
trouble understanding how and why it worked.

> it took a long time to figure out how and why this works, and I can't
> remember the details anymore.

Consider this updated copy of the code with more comments outlining why it
works.

<figure>
{% highlight c %}
// Computes an approximate value for 1 / sqrt( x ) using the Newton-Raphson
// method instead of normal floating point math for better speed
// See http://www.lomont.org/Math/Papers/2003/InvSqrt.pdf for derivation
float InvSqrt(float x)
{
    // Gives initial guess y0
    // The constant is derived mathemagically
    long i = * ( long * ) &x;
    i = 0x5f375a86 - ( i >> 1 );
    float y =  * ( float * ) &i;

    // Newton-Raphson step, repeating increases accuracy
    float xhalf = 0.5f * x;
    y = y * ( 1.5f - xhalf * y * y );
    return y;
}
{% endhighlight %}
<figcaption>Updated source code with simplified comments based on <a href="http://www.lomont.org/Math/Papers/2003/InvSqrt.pdf">Chris Lomont's paper</a></figcaption>
</figure>

If I needed to understand code like this on a daily basis I would hope it has comments
to go with it. These added comments help by describing why it works and
how it was derived. Better comments can help the next developer understand your
code more easily.

As Needed And Straight To The Point
===============================================================================

Too many comments will dilute your code. I prefer fewer comments and like to
the let the code speak for itself. Comments should not be a novel, keep them
as short and concise as possible. Too many comments is a code smell and might
be a sign you need to be less clever in your code. Updating the code to
be clearer would be a better use of your time than explaining unnecessarily
complex dependencies.

Recently we found code that looked like this:

{% highlight csharp %}
public class Result {
    public bool IsDraftPost { get; set; }
}
{% endhighlight %}

The code had the concept of drafts and posts, but not draft posts. After
looking at the surrounding code for a while, we learned this property indicated
when a draft was being posted. We then added a comment for the next person.

{% highlight csharp %}
public class Result {
    // Indicates a draft is being posted.
    public bool IsDraftPost { get; set; }
}
{% endhighlight %}

Instead of this fancy comment we could have updated the code to use a better
name and been done with it. We could say more with less.

{% highlight csharp %}
public class Result {
    public bool IsDraftBeingPosted { get; set; }
}
{% endhighlight %}

Kept Up To Date
===============================================================================

As comments become out of date they become more dangerous than no comments
at all. Out of date comments are misleading and can result in other
developers (or you in 6 months) doing bad things. For example, leaving a
parameter ``null`` based on the old comments, that will now throw an exception.

Documentation/comments that are no longer up to date makes the code they explain less
trust worthy. When the comments are misleading it is reasonable to assume the
code has deeper issues. The more arcane the code, the more crippling outdated
comments can be and the larger the impact caused by the resulting bad assumptions.

The best way to keep comments up to date is keeping them with the code. Put
comments right on your methods or around complex logic. Jeff Atwood takes this
even further and believes ["The value of a comment is directly proportional to the distance between the comment and the code."][good-comments].

I definitely agree with this and try to keep any related documentation
with the code. In addition to normal comments, our team has been committing
user/release documentation alongside our code and [shipping them][boring]
with the application. This has helped simplify and consolidate our
documentation.

Conclusion
===============================================================================

Good comments are a great way to explain code that is hard to follow. When dealing
with legacy code, be kind to other developers and leave comments based on what
you learn. Keep comments up-to-date, keep comments simple and keep comments
explaining the why/unobvious behind the code.

Happy commenting!

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[history-1]: http://www.beyond3d.com/content/articles/8/
[history-2]: http://www.beyond3d.com/content/articles/15/
[boring]: {% post_url 2015-01-21-deploys-becoming-boring-part-2 %}#managing-the-change
[good-comments]: http://blog.codinghorror.com/when-good-comments-go-bad/
