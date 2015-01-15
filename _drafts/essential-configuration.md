---
layout: post
title:  "Essential Configuration"
date:   2014-09-22 23:11:07
tags: design configuration
---

I have been thinking about the idea that every application has a perfect
minimum configuration. You know the Goldilocks Configuration that just feels
right where it has just the right information and no more or less.

New applications we wrote need **LOTS** of configuration to work. This has been
a big sticking point for our users and for good reason. It makes things hard
and painful when you first use our services but after the first use that pain
goes away.

Our Challenge
===============================================================================

We want our applications to be easy to use and maintain. Doesn't everyone? For
the domain we are working in, deploying complex software, the list of essential
things that you need to get your jobs done is very long.

Let's take a simple example, cloning a virtual machine from a template. You need
the following information just to do something reasonable.

1. What do you want to name your new machine?
2. What template are you going to clone from?
3. What credentials do you want to use to connect to your hypervisor?
4. Where do you want to store the new virtual machine?
5. Which host should be running the new virtual machine?

You might be able to skip 4-5 and pick intelligently from the hardware
available, but if operations wants to control that then you need to let them
configure it. The ability to choose makes the system more powerful but comes at
a cost when configuring the application and any future maintenance on the code.

This was the exact problem we faced when we built a tool called Machinator
<sup id="reverse-note-1"><a href="#note-1">1</a></sup> that creates virtual
machines. We could either have users provide all of this information through
the API or hide it as configuration within the system but would be unable to
eliminate any of this configuration. From these initial pieces of information
required we determined what our essential configuration needed to be for the
operation we wanted to accomplish.

The Ideal
===============================================================================

I think the ideal to strive for with any application is to not have any
configuration. Ideally your application would just work out of the box without
any additional work.

Configuration increases application complexity and potential ways that things
can go wrong. Like any other user input the values are a potential way to break
the application and need to be validated. This much more complicated when the
settings are coupled to one another or infrastructure connected to the
application. For Machinator, as underlying hardware changed these settings
would need to be maintained and monitoring became even more important when
issues happened.

Settings should be maintained over time and if you are evolving quickly can
become bloat that makes supporting your application harder. Testing the
application completely becomes combinatorially larger with additional settings.
You create the potential for odd corner cases that do not interact well or are
confusing to your users. For our application we have tried to make all updates
online and maintain a policy of 'no breaking changes'. Extra design effort was
needed to ensure new configuration did not affect old functionality and was not
required prior to the update.

I think software configuration and options are truly a case where less is more.
Your goal should be to get down to only the essential configuration required
for your application to run and no more. This means ruthlessly simplifying how
settings are determined and getting down to the absolute fewest options
possible.

Eliminate Unnecessary Configuration
===============================================================================

The best way to reduce your configuration options is to remove many options as
possible. If you have the essential configuration then you have absolute
minimum required for your application. How can you eliminate unnecessary
configuration? I think there are many ways to do so but not all might make
sense for your application.

**Do all clients have the same value for a setting?** It is a constant in
disguise and should be treated like one. Use the value and remove the setting.

**Unused functionality or configuration?** Deprecate
and remove the code eliminating the need to support these options. If you are
keeping around dead code for a rainy day remove it! You can always bring it
back from source control if you need it. Keeping it around and maintaining it
is taking your attention away from the things you actually should be doing.
Sometimes settings are added in anticipation for a potential need but forgotten
and then never used. These too need to go!

**Provide defaults wherever possible.** Defaults improve the "out of the box"
experience and good defaults let most customers not care about a setting.
Again if every client uses the default then it becomes a good candidate to
remove completely. Another technique is configuring groups of options that
can be used together. In some systems we have used hierarchical settings to
provide more flexible defaults or layering. We learnt this technique from
[hiera][hiera] when first adopting Puppet and have tried to apply it when it
made sense.

**Does the configuration have an expiry?** We use configuration for feature
flags and other use cases that should be short lived. Put a reminder into the
code or issue tracker to come back and remove the setting. We included a bunch
of explicit configuration to provide fall back options if some infrastructure
was not working. We have since made these areas robust enough that the old
settings can be removed.

**Can it be simpler?** You could have users provide large lists of options or
use a simple regex to select from existing items. Duplication is a good
indicator that things could be made simpler. We were able to change our
configuration to eliminate duplication resulting in a much clearer settings
that contained the bare minimum information. Remember [DRY][dry] is your friend.

Conventions over Configuration
===============================================================================

Strong conventions that imply configuration can remove the need for explicit
configuration. This is a very powerful way to strip down your configuration and
make it easier to understand your application. This technique can reduce the
configuration size and complexity while retaining much of the power and
flexibility. While typically applied to code it is also readily applicable to
any application settings.

Take the following example:

{% highlight csharp %}
using System;
using System.Linq;
using Autofac;

namespace Conventions {
    internal class InterfaceConventionsModule : Module  {
        protected override void Load( ContainerBuilder builder ) {
            var types = from t in ThisAssembly.GetTypes()
                        let i = t.GetInterface( "I" + t.Name, true )
                        where i != null
                        select new { Interface = i, Type = t };

            foreach( var type in types ) {
                builder.RegisterType( type.Type ).As( type.Interface );
            }
        }
    }
}
{% endhighlight %}

This small but potent piece of code will register every concrete type, ``Type``, who
implements n interface named ``IType`` with [Autofac][autofac], a dependency injection
framework. In code applying conventions like this helps make most programs more
consistent and easier to understand. You can navigate through the codebase
using conventions.

We have many examples of conventions throughout our new application. A really
simple one is using filenames as identifiers to tie different settings together.
In another application we used predefined directories to structure assets
within packages and then alphabetical order for the files within the
directories. These simple conventions made it very easy to understand how the
application worked and the order it would consume the files in.

It can be beneficial to allow users to extend or define their own conventions.
You can see this used by [Entity Framework][ef]<sup id="reverse-note-2"><a href="#note-2">2</a></sup>
to allow new conventions to be added. We use this effectively with [hiera][hiera]
to provider greater consistency for determining how servers are configured. If
you feel this is necessary for your situation I would highly recommend
proceeding with caution. Due to the power this provides it can accidentally be
misused and increase the complexity of your application dramatically.

Closing Thoughts
===============================================================================

Pursuing simpler configuration that contains only the essential elements for
your application is worthwhile. There are many aspects to consider when doing
so that will be applicable to your application. Understanding what can be
eliminated and where conventions are appropriate can help address this problem.

We have needed to work hard to minimize our configuration and continue refining
what is included always strive to reduce complexity. Machinator has benefited
from the ideas here and allowed us to progressively refine what settings were
needed. We use conventions heavily to group common settings together logically.
Cascading settings provide defaults for common options that vary infrequently.
Features that were once necessary have been removed to avoid unwanted choices.
With each iteration we have been able to refine what is included, remove
unnecessary options, determine sensible defaults and leverage conventions to
standardize our configuration all in the pursuit of our essential
configuration.

<hr />

<a id="note-1" href="#reverse-note-1">1.</a>
*Disclaimer:* Yes this is the same Machinator from my
[Lib, Service or Component][lsb] post.

<a id="note-2" href="#reverse-note-2">2.</a>
*Disclaimer:* I have not used Entity Framework in an application. My goal has
been to keep all applications small enough that a tool like [Dapper][dapper] is
more than sufficient.

[hiera]: https://docs.puppetlabs.com/hiera/1/
[autofac]: http://autofac.org/
[dry]: http://www.artima.com/intv/dry.html
[ef]:  http://msdn.microsoft.com/en-us/data/jj819164.aspx
[lsb]: {% post_url 2015-01-07-what-is-it-going-to-be-library-service-component %}
[dapper]: https://github.com/StackExchange/dapper-dot-net