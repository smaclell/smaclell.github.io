---
layout: post
title:  "Essential Configuration"
date:   2014-09-22 23:11:07
tags: design configuration
image:
  feature: essential-configuration.jpg
---

I have been thinking about the idea that every application has a perfect
minimum configuration. You know the Goldilocks Configuration that just feels
good with the right amount of information. No more or less.

New applications we wrote need **LOTS** of configuration to work. This has been
a big sticking point for our users and for good reason. It makes things hard
and painful when you first use our services and continues to be a challenge
while operating the services.

Our Challenge
===============================================================================

We want our applications to be easy to use and maintain. Doesn't everyone? For
the domain we are working in, deploying complex software, the list of essential
things that you need to get your jobs done is very long.

Let's take a simple example, cloning a virtual machine from a template. You need
the following information to do something reasonable and perform the action.

1. What do you want to name your new machine?
2. What template are you going to clone from?
3. How do you want to connect to your hypervisor? What are the credentials?
4. Where do you want to store the new virtual machine?
5. Which host should be running the new virtual machine?
6. etc.

You might be able to skip some of the later options, but doing so limits the
control your operators may want. The ability to choose these options makes the
system more powerful, but comes at a cost when configuring the application and
any future maintenance on the code.

This was the exact problem we faced when we built Machinator,
<sup id="essential-configuration-reverse-note-1"><a href="#essential-configuration-note-1">1</a></sup> a service that creates virtual
machines. We could either have users provide all of this information through
the API or hide it as configuration within the system, but would be unable to
eliminate any of this configuration. From the required settings, we determined
what our essential configuration needed to be for the operations we wanted to
accomplish.

The Ideal
===============================================================================

I think the ideal to strive toward with any application is to not have any
configuration. Ideally your application would just work out of the box without
any additional settings.

Configuration increases application complexity and the potential ways things
can go wrong. Like any user input, configuration settings provide a way to break
applications and need to be validated. This much more complicated when the
settings are coupled to one another or infrastructure connected to the
application. For Machinator, as underlying hardware changed these settings
would need to be maintained. Monitoring and validating the settings is
important and highlights issues with connected services.

Settings should be maintained over time and if you are evolving quickly can
become bloat that makes updating your application harder. Testing the
application completely becomes combinatorially larger with additional settings.
You create the potential for odd corner cases that do not interact well or are
confusing to your users. For our application we make all updates
online and maintain a policy of "no breaking changes". Extra design effort was
needed to ensure new configuration did not affect old functionality or
need to be configured before deploying.

I think software configuration and options are a case where less is more.
Your goal should be to reduce the configuration so that only the essential
settings needed by the application to run are included and no more. This means
ruthlessly getting down to the absolute fewest options possible and simplifying
how they are determined.

Eliminate Unnecessary Configuration
===============================================================================

The best way to reduce your configuration is to remove as many options as
possible. To have only the essential configuration then you must have the
absolute minimum required for your application. How can you eliminate
unnecessary configuration? I think there are many ways to do so which might be
useful depending on your context.

**Do all clients have the same value for a setting?** It is a constant in
disguise and should be treated like one. Use the value and remove the setting.

**Unused functionality or configuration?** Deprecate
and remove the code eliminating the need to support these options. If you are
keeping around dead code for a rainy day, remove it! You can always bring it
back from source control if you need it. Keeping it around and maintaining it
is taking your attention away from something else more important you could be doing.
Sometimes settings are added in anticipation for a potential need, but are then
forgotten and never used. These need to be deleted!

**Provide defaults wherever possible.** Defaults improve the "out of the box"
experience and good defaults let most customers not care about a setting.
Again, if every client uses the default then it becomes a good candidate to
remove completely. Another technique is configuring groups of options which
can be used together. In some systems we have used hierarchical settings to
provide more flexible defaults or layering. We learnt this technique from
[hiera][hiera] when first adopting Puppet and have tried to apply it when it
made sense.

**Does the configuration have an expiry?** We use configuration for feature
flags and other use cases that should be short lived. Put a reminder into the
code or issue tracker to come back and remove the setting later. We included a bunch
of configuration so more complicated options could be configured explicitly to
provide a fall back if some infrastructure was not working or workaround issues in the code. We have since
made these areas robust enough that the extra settings can be removed.

**Can it be simpler?** You could have users provide large lists of options or
use a simple regex to select from existing items. Duplication is a good
indicator that things could be made simpler. We were able to change our
configuration to eliminate duplication resulting in a much clearer settings
containing the bare minimum information. Remember [DRY][dry] is your friend.

**[YAGNI][yagni].** Some settings might not be needed yet and should be left
until later. I was recently refactoring some code that implemented a
state machine and a coworker suggested I make it externally configurable.
It would have allowed the system to be reused for other activities, but would
have introduced complicated configuration which would be easy to get wrong.
We could happily defer this request until later when hopefully we have a
concrete problem to solve and/or other systems that simplify the solution.

Conventions over Configuration
===============================================================================

Strong conventions that imply configuration can remove the need for explicit
configuration. This is a very powerful way to strip down your configuration
size and complexity while retaining much of the utility and
flexibility. This pattern is typically applied to code, it is also readily applicable to
application settings.

Take the following gratuitous example:

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

This small but potent code will register every concrete type, ``Service``, that
implements an similarly interface named ``IService`` with [Autofac][autofac], a dependency injection
framework. Code applying conventions like this helps make most programs more
consistent and as a result easier to understand. Many frameworks leverage
common conventions to simplify normal tasks like [registering all ASP.NET MVC Controllers in Autofac][controllers].

It can be beneficial to allow users to extend or define their own conventions.
For example, instead of something like my example above you could use the built in
[assembly scanning][scanning] in Autofac to define your own conventions.
Another example would be [Entity Framework][ef]<sup id="essential-configuration-reverse-note-2"><a href="#essential-configuration-note-2">2</a></sup>
which allows new conventions to be added. If you feel allowing users to apply
their own conventions is necessary I would recommend proceeding with caution.
Due to the power this provides it can enable much more complicated runtime behaviour that
is harder to audit and validate than explicit settings or using existing conventions. This is why
extensible conventions is typically reserved for programming frameworks where
the audience is expected to understand the trade-offs, be more technically
inclined and can be tested more safely away from production.

We have many examples of conventions throughout our new applications. A really
simple one is using filenames as identifiers to tie different settings together.
In another application we used predefined directories to structure assets
and then alphabetical order to process the files within the directories. These
simple conventions made it very easy to understand how the
application worked and made the assets more consistent.

Closing Thoughts
===============================================================================

Pursuing simpler configuration that contains only the essential elements for
your application is worthwhile. There are many aspects to consider when
simplifying your application's configuration. Understanding what can be
eliminated and where conventions are appropriate can help address this problem.

We have needed to work hard to minimize our configuration and always strive to
reduce complexity by refining what is included. Machinator has benefited
from these ideas and allowed us to progressively improve what settings were
needed. We use conventions heavily to group common settings together logically.
Cascading defaults for common options removes redundant settings and can be
overridden when the default is not enough.
Features that were once necessary have been removed to avoid unwanted choices
and simplify the code.

With each iteration we have been able to refine what is included, remove
unnecessary options, determine sensible defaults and leverage conventions to
standardize our configuration all in the pursuit of our essential
configuration.

What is the essential configuration for your application?

<hr />

<a id="essential-configuration-note-1" href="#essential-configuration-reverse-note-1">1.</a>
Yes this is the same Machinator from my [Lib, Service or Component][lsb] post.

<a id="essential-configuration-note-2" href="#essential-configuration-reverse-note-2">2.</a>
*Disclaimer:* I have not used Entity Framework in a production application. My goal has
been to keep all applications small enough that a tool like [Dapper][dapper] is
more than sufficient.

[hiera]: https://docs.puppetlabs.com/hiera/1/#avoiding-repetition
[autofac]: http://autofac.org/
[controllers]: http://docs.autofac.org/en/latest/integration/mvc.html
[scanning]: http://docs.autofac.org/en/latest/register/scanning.html
[dry]: http://www.artima.com/intv/dry.html
[yagni]: http://c2.com/cgi/wiki?YouArentGonnaNeedIt
[ef]:  http://msdn.microsoft.com/en-us/data/jj819164.aspx
[lsb]: {% post_url 2015-01-07-what-is-it-going-to-be-library-service-component %}
[dapper]: https://github.com/StackExchange/dapper-dot-net