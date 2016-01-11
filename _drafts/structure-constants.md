---
layout: post
title:  "Immutable + Static = Structured Constants"
description: "How we now setup our PowerShell projects to keep them easy to maintain."
date:   2015-12-30 23:45:07
tags: powershell conventions maintenance
image:
  feature: https://farm8.staticflickr.com/7528/15037595713_077b784de6_b.jpg
  credit: "The artist by Shawn Harquail - CC BY-NC 2.0"
  creditlink: https://www.flickr.com/photos/harquail/15037595713/
---

This is a fun trick. I have been using a combination of immutable objects and
static fields to declare data within our application. The fields for the object
are all related to one another and never change. They are useful as values
throughout the application and benefit from being declared constants.

{% highlight csharp %}
public class Pokemon {
    internal class PokemonData(
        int number,
        string name,
        PokemonType type,
        PokemonData evolvesFrom = null
    ) {
        public int Number { get; } = number;
        public string Name { get; } = name;
        public PokemonType Type { get; } = type;
        public PokemonData EvolvesFrom { get; } = evolvesFrom;
    }

    internal PokemonData Bulbasaur = new PokemonData( 1, "Bulbasaur", PokemonType.Grass | PokemonType.Poison );
    internal PokemonData Ivysaur = new PokemonData( 2, "Ivysaur", PokemonType.Grass | PokemonType.Poison, Bulbasaur );
    internal PokemonData Venusaur = new PokemonData( 3, "Venusaur", PokemonType.Grass | PokemonType.Poison, Ivysaur );

    internal PokemonData Charmander = new PokemonData( 1, "Charmander", PokemonType.Fire );
    internal PokemonData Charmeleon = new PokemonData( 2, "Charmeleon", PokemonType.Fire, Charmander );
    internal PokemonData Charizard = new PokemonData( 3, "Charizard", PokemonType.Fire | PokemonType.Flying, Charmeleon );

    // Repeat
}
{% endhighlight %}