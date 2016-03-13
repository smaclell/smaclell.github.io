---
layout: post
title:  "Do Your Layers Add Value?"
description: "How we now setup our PowerShell projects to keep them easy to maintain."
date:   2015-12-30 23:45:07
tags: powershell conventions maintenance
image:
  feature: https://farm8.staticflickr.com/7528/15037595713_077b784de6_b.jpg
  credit: "The artist by Shawn Harquail - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/harquail/15037595713/
---

Layers in your application are a great way to break up code into delicious
bitesized pieces. They can also be a waste of time and make troubleshooting
harder. Cut through the bloat to get the real value.

We had an interesting discussion this week about the Factory pattern. Our one
application has thousands of classes and interfaces with Factory in the name.
At one point they were great and made creating classes easier. Now, they are a
hold over from a time before [Dependency Injection][di].

The once valuable Factories are not as valuable. These are extra layers which
we can mostly delete. A factory for a class with only one implementation is
trivial to setup with Dependency Injection. This factory provides no value:

{% highlight csharp %}
public class FooFactory {
    public IFoo Create() {
        return new Foo();
    }
}
{% endhighlight %}

There are a however a few which are still valuable to keep using. They are
more complicated. Often they include logic which will pull together multiple
dependencies or alter the behaviour depending on settings or context. These
Factories are good and should be kept around.

{% highlight csharp %}
public class FooFactory {
    public IFoo Create() {
        IFoo real = new Foo();
        IFoo logging = new LoggingFoo( real );
        IFoo caching = new CachingFoo( logging );

        return caching;
    }
}
{% endhighlight %}

The moral of the story is we should only use the factories when they add value.
Everywhere else they should be removed to reduce the amount of code we maintain.

Layering to catch exceptions
Layers for caching

Single implementation of an interface. Good for behaviours. Bad for data. Use a simple data class.

Think about what value the layering is adding.

[di]: TODO