---
layout: post
title:  "Exterminators Week 3 - Enter the Comments"
date:   2015-03-30 00:09:07
tags: goals improvement career focus quality exterminator
---

Comments can be a great way to learn new code and document unintuitive
behaviour. Good comments succinctly explain why code was done a certain way and
are kept up to date.

This week I have found myself adding more comments to code than ever before.
I think this is partially due to the code I am in as I try to understand it and
also part of the culture on the [Exterminator][tribute] team. It is part of how
the team works and leaving the documentation better than how you found it is a
part of every code review.

The team tries to add comments to any code they touch to document the behaviour
they are seeing. For every weird bug we solve, we can save the next person who
reads the code time understanding why it works the way it does. Together, we
have been able to slowly grow the documentation and tests along with the
changes we are making, leaving the updated code better than we found it.

In the past I have tried to rely solely on unit tests or naming to describe the
code. This works great for new code where it is easy to understand how
different classes are connected. In [legacy code][legacy] code where there are
no tests and the behaviour is unclear, relying only on naming and relationships
is not enough. Good comments along side the code and meaningful names can
change something from unintelligible to usable.

So what makes a good comment?

**Good comments document why decisions were made and the not obvious code.**

Without recreating the thinking from the original developer it
can be impossible to know why code has been written a specific way. This is why
it is important for comments to explain concepts and connections that are not
obvious.

Take this wild code found in the Quake III source code:

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
<figcaption>The source code from <a href="http://en.wikipedia.org/wiki/Fast_inverse_square_root">wikipedia</a> (edited to be family friendly and line up more)</figcaption>
</figure>

It computes the inverse square root using a Newton-Raphson approximation. Extra
bit magic is used to perform the computation as an integer instead of floating
point for pure speed. The resulting code was ~4 times faster using the hardware
of the day (i.e. before dedicated SSE instructions). This speed boost would be
critical for the high performance needed by the game engine. This codes has
some [interesting][history-1] [history][history-2] tracing the potential
authors and how it was implemented.

This code is not intuitive for mere mortals and the few comments it has might
be moderately helpful. This is a comment from one of the developers, Gary
Tarolli, who also had trouble understanding it why it worked.

> it took a long time to figure out how and why this works, and I can't
> remember the details anymore.

Consider this updated copy of the code with more comments outlining why it
works.

<figure>
{% highlight c %}
// Computes an approximate value for 1 / sqrt( x )
// using the Newton-Raphson method for speed
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

If I responsible for maintaining code like this I would hope it has comments
to go with with it. These added comments help by describing why it works and
how it was derived. Better comments can help the next developer understand your
code faster and save them the time when trying to understand it.

**Good comments are straight to the point and used only as needed.**

Too many comments will dilute your code. I prefer fewer comments and like to
the let the code speak for itself. Comments should not be a novel, keep them
as short and concise as possible. Too many comments is a code smell and might
be a sign you need to be less clever in your code. Updating the code itself to
be clearer would be more useful.

Recently we had some code that looks like this:

{% highlight csharp %}
class Result {
    bool IsDraftPost { get; set; }
}
{% endhighlight %}

The code had the concept of drafts and posts, but not draft posts. After
looking at it for a long time learned it was meant for drafts becoming posts
so added a comment for the next person.

{% highlight csharp %}
class Result {
    /// Indicates a draft that is being posted.
    bool IsDraftPost { get; set; }
}
{% endhighlight %}

Instead of this fancy comment we could have updated the code to use a better
name and been done with it. We could say more with less.

{% highlight csharp %}
class Result {
    bool IsDraftBecomingPost { get; set; }
}
{% endhighlight %}

**Good comments are kept up to date with the code.**

As soon as comments fall out of date they are more dangerous than no comments
at all. Out of date comments are misleading and could result in other
developers (or you in 6 months) doing bad things with code. Think leaving a
parameter ``null`` that will now throw an exception.

Documentation/comments that are no longer up to date makes the code they explain less
trust worthy. When the comments are misleading it is reasonable to assume the
code also has issues. The more arcane the code, the more crippling bad comments
can be and the effect of bad assumptions they cause.

The best way to keep comments up to date is keeping them with the code. Put
comments right on your methods or around complex logic. Jeff Atwood takes this
even further and believes ["The value of a comment is directly proportional to the distance between the comment and the code."][good-comments].

I definitely agree with this and try to keep any code related documentation
with the code. In addition to normal comments, our team has been committing
user/release documentation alongside our code and [shipping the docs][boring]
with the application. This has helped simplify and consolidate our
documentation.

**Conclusion**

Good comments are a great way to explain code that is hard to follow. Use
comments when needed and help the next person who comes along. When dealing
with legacy code, be kind to other developers and leave comments based on what
your learn. Keep comments up-to-date, keep comments simple and keep comments
explaining the why behind the code or the not obvious.

Happy commenting!

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[history-1]: http://www.beyond3d.com/content/articles/8/
[history-2]: http://www.beyond3d.com/content/articles/15/
[boring]: {% post_url 2015-01-21-deploys-becoming-boring-part-2 %}#managing-the-change
[good-comments]: http://blog.codinghorror.com/when-good-comments-go-bad/
