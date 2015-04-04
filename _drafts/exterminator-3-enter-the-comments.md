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

**Documents intent, not what is being done.**

Without recreating the exact moment and thinking from the original developer it
can be impossible to know why code has been written a specific way. Explain
concepts and connections that are not obvious. What is not obvious my differ
between developers so if you are not sure about some code you are reading ask
what someone else thinks.

This would be a bad comment

{% highlight csharp %}
// An immutable 2D Point
public struct Point {
    public int X { get; private set; }
    public int Y { get; private set; }

    public Point(int x, int y) {
        X = x;
        Y = y;
    }
}
{% endhighlight %}

{% highlight csharp %}
// For simple computations with 2D Points not long lived objects that move over time
// Points are expected to be short lived and are struct's so they can be GC'd early
// This is also immutable to prevent long lived objects that would be updated
public struct Point {
    public int X { get; private set; }
    public int Y { get; private set; }

    public Point(int x, int y) {
        X = x;
        Y = y;
    }
}
{% endhighlight %}

// Immutable
// Odd ordering
// Wierd fields
// Repitition

{% highlight csharp %}
public static IEnumerable<Items> UpdateItems(
    IEnumerable<int> existing,
    IEnumerable<int> added,
    IEnumerable<int> removed
) {
    // Add all the removed items to a HashSet
    HashSet<int> allRemoved = new HashSet<int>();
    foreach( int x in removed ) {
        allRemoved.Add( x );
    }

    // Removes items then adds the new items
    return existing.Where( x => !allRemoved.Contains( x ) )
            .Concat( added );
}
{% endhighlight %}

Instead of saying what the code is doing, a good comment would say why.

{% highlight csharp %}

// Items are an immutable list to not affect existing lists
public static IEnumerable<Items> UpdateItems(
    IEnumerable<int> existing,
    IEnumerable<int> added,
    IEnumerable<int> removed
) {
    HashSet<int> allRemoved = new HashSet<int>();
    foreach( int x in removed ) {
        allRemoved.Add( x );
    }

    return existing.Where( x => !allRemoved.Contains( x ) )
            .Concat( added );
}
{% endhighlight %}


**Kept up to date with the code.**

As soon as comments fall out of date they are more dangerous than no comments
at all. Out of date comments are misleading and could result in other
developers (or you in 6 months) doing bad things with code. Think leaving a
parameter ``null`` that will now throw an exception.

The best way to keep comments up to date is keeping them with the code. Put
comments right on your methods or around complex logic. Jeff Atwood takes this
even further and believes ["The value of a comment is directly proportional to the distance between the comment and the code."][good-comments].

**Are straight to the point and used only as needed.**

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

**Conclusion**

Good comments are a great way to explain code that is hard to follow. Use
comments when needed and help the next person who comes along. Keep them
simple, keep them up-to-date and keep them saying why not what.

Happy commenting!

[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[legacy]: {% post_url 2015-03-16-exterminators-1-the-4-stages-of-legacy-code %}
[good-comments]: http://blog.codinghorror.com/when-good-comments-go-bad/
