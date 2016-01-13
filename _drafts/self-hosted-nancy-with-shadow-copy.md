---
layout: post
title:  "How to Self-Host Nancy Without Locking Your DLLs: Shadow Copying"
description: "How we now setup our PowerShell projects to keep them easy to maintain."
date:   2015-12-30 23:45:07
tags: nancyfx shadow-copy appdomains examples
image:
  feature: https://farm3.staticflickr.com/2841/11554965345_cd1e35c7fa_b.jpg
  credit: "Padlock by Nicki Mannix - CC BY 2.0"
  creditlink: https://www.flickr.com/photos/nickimm/11554965345/
---

This is in response to a GitHub [issue][issue] for [Nancy][nancyfx]. The user is trying to
self-host Nancy without locking their DLLs. One easy way to do this is
to create a wrapper program which runs the actual program with shadow copying assemblies.
No DLLs are locked and the changes are minimal.

I will first show a simple application which self-hosts Nancy and can serve a
request to ``"/"``. The program will start listening, wait for a key to be
pressed and then exit. This is the code:

{% highlight csharp %}
using System;
using Nancy;
using Nancy.Hosting.Self;

class Program {
    static void Main( string[] args ) {

        var url = new Uri( "http://localhost:12345" );
        using ( var host = new NancyHost( new DefaultNancyBootstrapper(), url ) ) {
            host.Start();

            Console.WriteLine( "Now listening, have fun!" );

            Console.ReadLine();
        }

    }
}
{% endhighlight %}

We will add a simple ``NancyModule`` so we can test the application at ``http://localhost:12345/``:

{% highlight csharp %}
using System;
using Nancy;

public class HelloWorldService : NancyModule {
    public HelloWorldService() {

        Get["/"] = x => {
            return Response.AsText( "Hello World" );
        };

    }
}
{% endhighlight %}

This program will work as is. The problem is that it locks any assemblies it references.

To work around this problem, add another executable to wrap the actual
implementation. In order to keep the DLLs unlocked, we will run the implementation from
a separate [AppDomain][appdomain] with [Shadow Copying][shadow] enabled.

AppDomains are a very powerful feature of
the Common Language Runtime for isolating code. They can use different security
contexts, modify how assemblies are loaded and can be managed independently.
There can be multiple AppDomains within a single process and can achieve some
of the same isolation benefits as processes.

Using the separate AppDomain allows us to set the ``ShadowCopyFiles`` option to ``"true"``. This option will cause the
assembly loading process to copy each assembly into a different directory and then load them from the new location.
The local copies are left unlocked. For more information on [Shadow Copying Assemblies][shadow] refer to MSDN.

The whole solution would look like the diagram below:

<figure class="image-center">
	<img src="{{ site.url }}/images/wrapper-executable.jpg" alt="The wrapper executable calling the actual program to run it" />
</figure>

This is the wrapper program to call the actual executable ``Implementation.exe``:

{% highlight csharp %}
using System;

class Program {
    static int Main( string[] args ) {

        AppDomainSetup setup = new AppDomainSetup {
            ShadowCopyFiles = "true" // This is key
        };

        var domain = AppDomain.CreateDomain( "Real AppDomain", null, setup );

        // Execute your real application in the new app domain
        int result = domain.ExecuteAssembly(
            "Implementation.exe",
            args
        );

        return result;

    }
}
{% endhighlight %}

That is all there is to it. Don't want your DLLs to be locked? The easy solution
is to use another AppDomain with Shadow Copying enabled.

**All the code for this blog post can be found in this [sample project][project].**

[issue]: https://github.com/NancyFx/Nancy/issues/2123
[nancyfx]: http://nancyfx.org/
[appdomain]: https://msdn.microsoft.com/en-us/library/2bh4z9hs(v=vs.110).aspx
[shadow]: https://msdn.microsoft.com/en-us/library/ms404279(v=vs.110).aspx
[project]: https://github.com/smaclell/NancyShadowAssemblies
