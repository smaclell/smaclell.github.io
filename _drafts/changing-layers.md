---
layout: post
title:  "Changing Layers"
date:   2015-07-24 01:19:07
tags: development design daryl
---

This is a story about making a change and how layering played in. The code
started with an outer layer which depended on an inner layer. It started
with a prototype only changing the outer layer which did not sit well with
my coworker, Daryl, who wanted me changing only the inner layer. Later, we
in the code review we realized we could combine the two layers and clean up
the application.

The both layers were responsible for accessing a collection of setting values
and the meta data. The application will only have a handful of these settings,
which are heavily read and readonly.

The settings data looks includes a ``Key`` and ``Value`` and looks like this:

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

Whereas the the outer layer's interface supports a key value lookup on the
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
configuration files and then result all of the settings. The outer layer would
call the inner layer to get all the settings and then cache the results for the
key/value lookup. Since there would only be a handful of settings and they are
so heavily read this works great. Very few parts of the application call the
inner layer, but many code paths indirectly use the values provided by the
outer layer.

We wanted to allow a the settings to be looked up from a key/value source.
Using a single configuration file would not work for some of the more dynamic
workloads we want to support. We could optionally enable the key/value source
and use it to switch which settings would be available when a process was
launched. This would again provide readonly values, but makes changing the
settings between different workloads much easier.

Backwards
===============================================================================

Before committing to using this new source I made a small prototype
demonstrating the key/value source working with our application. I included a
new implementation of the outer layer's interface. I then updated the factory
responsible for creating getting the implementation to create my new class when
the key/value source was enabled.

I liked this alot. I was extremely clean and did exactly what I wanted. The new
implementation perfectly fit the interface for the outer layer.
``TryGetSetting`` is a key/value lookup so what better interface for reading
from the key/value store.

While this was good for a prototype it was not enough to ship. Daryl, an
awesome coworker, did not like how I skipped the inner layer. After all the
outer layer calls the inner layer to get all the settings. My work was half
done and if I picked the other interface it would have implemented everything.

After talking, I realized Daryl was right. In addition to being half done my
implementation was changing the wrong layer. However, I still like how clean my
solution. We threw out the prototype and started the real solution.

Combining
===============================================================================

With the final pull request I started by implementing both interfaces
separately. The direct key/value lookup was great and it was easy to implement
the inner layer to get all values.

I noticed both implementations were very similar and decided to combine them:

{% highlight csharp %}
class KeyValueProvider : ISettingsProvider, ISettingsValueProvider {

	const string Prefix = "SettingsPrefix";

	bool TryGetSetting(
		string key,
		out string settingsValue
	) {
		settingsValue = Get( key );
		return settingsValue != null;
	}

	IEnumerable<Settings> GetAllSettings() {
		foreach( string key in GetAllKeys() ) {
			if( !key.StartsWith( Prefix ) ) {
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

	// All the Get* implemented separately
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

The previous responsibilities for each class/interface were extremely narrow,
get a setting or get all settings. We combined the classes which meant there is
now a method for each of the original responsibilities.

Each methods has one responsibility and together they form a cohesive package.
We now encapsulate how a single data source was used. In the previous version
this was split between the layers. There is now one place to find the
implementation of ``ISettingsProvider`` for each data source, the configuration
file or the key/value store.

De-layering for Simplicity
===============================================================================

I think the combined layers are easier to understand. There are fewer classes
and moving parts to the system. With the extremely small interfaces you would
need to bounce around a lot more to understand the code. Given my short
attention span it can be really hard to trace all of the pieces.

Generally, I like having fewer layers. The best line of code is the one you
don't write. For really small classes I often don't see the value they provide.
What change at they allowing which was not possible or harder before?

If you are making a change across several layers think about which layer is the
best place to make your change. Think about whether you need all those layers
or if they would be better together.

Notes:

Show approximately the interfaces we were dealing with.
Setup the situation with and how the change came about.
* ConfigFile vs Key Value Lookup

Why the outer layer only is backwards.
* Other classes use the inner layer directly
* I liked how clean the outer layer was.
* Okay to show an idea, not good enough to ship.

Why just the inner layer would be okay.
* Changing it here might not need the outer layer to change

Doing both!

* The outer layer for the KV implementation is more direct
* Still need the inner layer for the callers, do both!

I tried combining them and liked what I saw. There was so little class and it pulled together
the single responsibility of how the lookup worked really well.

Why the combined layering is better.

* When I
* Simplicity!

[srp]: http://blog.codinghorror.com/curlys-law-do-one-thing/