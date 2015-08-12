---
layout: post
title:  "Changing Layers"
date:   2015-08-11 08:00:07
tags: development design daryl ershad
image:
  feature: lasagna.jpg
  credit: Jameson Fink CC BY 2.0 (resized)
  creditlink: https://www.flickr.com/photos/jamesonfink/11735294004/
---

This is a story about making a change and how layering played in. The code
started with an outer layer which depended on an inner layer. It started
with a prototype that changed only the outer layer. This did not sit well with
my coworker, Daryl, who wanted me changing only the inner layer. During the
code review, we realized we could combine the two layers and clean up the
application.

The both out and inner layers were responsible for accessing specialized
settings. These settings are special because of how heavily they are read and
are readonly while the application is running. The settings are often treated
like a key/value and there will only every be a handful of them for any
application.

The settings data includes a ``Key`` and ``Value`` and looks like this:

{% highlight csharp %}
class Settings {
    string Key { get; set; }
    string Value { get; set; }
    string Version { get; set; }
    string Type { get; set; }
}
{% endhighlight %}

The inner layer's interface provides access to all settings:

{% highlight csharp %}
interface ISettingsProvider {
    IEnumerable<Settings> GetAllSettings();
}
{% endhighlight %}

Whereas the outer layer's interface supports a key value lookup on the
``Settings.Value`` based on the ``Settings.Key``:

{% highlight csharp %}
interface ISettingsValueProvider {
    bool TryGetSetting(
        string key,
        out string settingsValue
    );
}
{% endhighlight %}

In the original version the inner layer's implementation would parse
configuration files and then return all of the settings. The outer layer would
call the inner layer to get all the settings and then cache the results for the
key/value lookup. Since there would only be a handful of settings and they are
so heavily read this works great. Very few parts of the application call the
inner layer, but many code paths indirectly use the values provided by the
outer layer.

We wanted to allow the settings to be looked up from a key/value source.
Using a single configuration file would not work for some of the more dynamic
workloads we want to support. Instead we wanted to enable the key/value source
with static values when the application launched. Switching values would then
be as easy as relaunching the application.

Backwards
===============================================================================

Before committing to using this new source I made a small prototype
demonstrating the key/value source working with our application. I included a
new implementation of the outer layer's interface. I then updated the factory
responsible for creating getting the implementation to create my new class when
the key/value source was enabled.

I liked this implementation a lot; it was extremely clean and did exactly what I wanted. The new
implementation perfectly fit the interface for the outer layer.
Since ``TryGetSetting`` is a key/value lookup it cleanly exposed to the underlying
key/value store.

While this was good for a prototype it was not enough to ship. Daryl,
did not like how I skipped the inner layer. After all, the
outer layer calls the inner layer to get all the settings. My work was half
done and if I picked the other interface it would have implemented everything.

After we talked, I realized Daryl was right. Though I liked how clean my
solution was, it was not complete and it was changing the wrong layer. We threw
out the prototype and started the real solution.

Combining
===============================================================================

With the final pull request I started by implementing both interfaces
separately. The direct key/value lookup was great and it was easy to implement
the inner layer to get all values.

I noticed both implementations were very similar and decided to combine them:

{% highlight csharp %}
class KeyValueProvider : ISettingsProvider, ISettingsValueProvider {

    bool TryGetSetting(
        string key,
        out string settingsValue
    ) {
        settingsValue = Get( key );
        return settingsValue != null;
    }

    IEnumerable<Settings> GetAllSettings() {
        foreach( string key in GetAllKeys() ) {
            if( !key.StartsWith( "SettingsPrefix" ) ) {
                continue;
            }

            yield return new Settings {
                Key = key,
                Value = Get( key ),
                Version = GetVersion( key ),
                Type = GetType( key )
            }
        }
    }

    ...
}
{% endhighlight %}

Daryl liked this. The original interfaces were very fine grained, but dealt
with the exact same data. The responsibility for looking up a single setting or
all settings was split. The separate interfaces made sense when it was first
implemented. Seeing them combined made us realize it would be simpler if they
were one interface:

{% highlight csharp %}
interface ISettingsProvider {
    IEnumerable<Settings> GetAllSettings();

    bool TryGetSetting(
        string key,
        out string settingsValue
    );
}
{% endhighlight %}

Violating the Single Responsibility Principle?
===============================================================================

Does this violate the [Single Responsibility Principle][srp]? Maybe.

The previous responsibilities for each class/interface were extremely narrow:
get a setting or get all settings. Combining the interfaces means the two
responsibilities are merged into a single class. Together in one class, the
methods are a more cohesive package.

The new design encapsulates how a single data source is used in one class. In
the previous version this was split between the layers. Now details for using a
configuration file or the key/value store are isolated in our
``ISettingsProvider`` implementations. Although this is a larger responsibility
than before, I think it is a reasonable way to break up the code.

I have drunk the SOLID Kool-Aid. For years I have tried to think hard about when
to apply each of the rules. While writing this post I found the article
"[I don't love the single responsibility principle][love]". Like the
[hacker news][hn] comments I don't agree with all the ideas here, especially
about the future being irrelevant. However, I completely agree with his
alternate class sizing principle:

> The purpose of classes is to organize code as to minimize complexity. Therefore, classes should be:
> 
> 1. small enough to lower coupling, but
> 2. large enough to maximize cohesion.
>
> By default, choose to group by functionality.
>
> <cite> -- [Marco Cecconi][marco] </cite>

This explanation makes perfect sense. Looking at the problem in terms of
cohesion and coupling got me thinking. There is a delicate balancing act
between massive classes doing too much and tiny classes with one narrow
reason to change.

The Balancing Act
===============================================================================

I spent the last 4 months as an [Exterminator][tribute] dealing with large classes which do way too much.
Thousands of lines and too many responsibilities to count. These classes need
to be broken up. The classes were heavily coupled and less cohesive due to
the many things they did.

Another common pattern is small classes which delegate most of their work to
other classes. They always have one tiny responsibility and their one reason to change has
never happened. For really small classes like these I often don't see the value
they provide. The coupling between these micro classes was very low, but they are
not cohesive enough to tie the system together.

I prefer chunkier cohesive classes. This means a class' one reason to change
will be a little bigger so I can have cleaner modules. In the example from this
post, the primary reason for a ``ISettingsProvider`` to change is when
accessing the underlying data source changes. Otherwise, the individual methods
should be very stable.

Originally, each layer abstracted a single method. Since the two layers were
intimately connected it made sense to combine them. We found this by looking
closer at how they interacted and experimenting. We thought it was a good
idea to combine them.

De-layering for Simplicity
===============================================================================

How do you know you have hit the sweet spot for your layering? You don't.
Deciding when to combine/split layers is arbitrary! Need help thinking through
or reviewing your layers? Try these methods:

* Code reviews
* Talking to others
* Prototype a change
* Consider the impact/effort for potential change
* Where are defects most likely or costly
* Liberally apply [YAGNI][yagni] to remove layers

I think the combined layers are easier to understand. There are fewer classes
and moving parts to the system. With the extremely small interfaces you would
need to bounce around a lot more to understand the code. Given my short
attention span it can be really hard to trace all of the pieces.

The code was loosely coupled, but not cohesive. We tilted the balance toward
combining responsibilities and classes and in this case I like the result.

If you are making a change across several layers think about which layer is the
best place to make your change. Think about whether you need all those layers
or if they would be better together.

<hr />

Thanks again Daryl for working through this change with me. I felt like I
learnt from our discussions and always enjoy when you are on my code
reviews.

Thank you also to Ershad who brought up the potential Single Responsibility
violation. I hope you liked my answer ;).

[srp]: http://c2.com/cgi/wiki?SingleResponsibilityPrinciple
[tribute]: {% post_url 2015-02-26-i-volunteer-as-tribute %}
[love]: http://www.sklivvz.com/posts/i-dont-love-the-single-responsibility-principle
[hn]: https://news.ycombinator.com/item?id=7707189
[marco]: https://twitter.com/sklivvz
[yagni]: http://martinfowler.com/bliki/Yagni.html
