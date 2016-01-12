---
layout: post
title:  "How to Self-Host Nancy Without Locking your DLLs: Shadow Copying"
description: "How we now setup our PowerShell projects to keep them easy to maintain."
date:   2015-12-30 23:45:07
tags: nancyfx shadow-copy appdomains examples
image:
  feature: https://farm3.staticflickr.com/2841/11554965345_cd1e35c7fa_b.jpg
  credit: "Padlock by Nicki Mannix - CC BY 2.0"
  creditlink: https://www.flickr.com/photos/nickimm/11554965345/
---

This is response to an [issue][issue] on the Nancy. The user is trying to
self-host Nancy without locking any of their DLLs. One easy way to do this is
creating a separate executable which shadow loads then runs the real program.
No DLLs are locked and your code barely changes.

In my example application I will have a ``Program`` to self-host Nancy and wait
for requests. Any key will kill the program. The code is pretty simple:

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

We will then add a simple ``NancyModule`` so we can test the application at ``http://localhost:12345/``:

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

This program will work as is. The problem is that it will lock all the
executables and assemblies.

To work around this problem we will add another executable to wrap the actual
implementation. Instead of running the code from the current directory we will
have it run the actual implementation from a separate [AppDomain][appdomain].

This allows us to enable the ``ShadowCopyFiles`` option to ``"true"`` which will cause the
assemblies to be loaded to another directory, preventing the local copies from
being locked.

This is the wrapper program to call the actual executable ``NancyShadowAssemblies.Implementation.exe``:

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
            "NancyShadowAssemblies.Implementation.exe",
            args
        );

        return result;

    }
}
{% endhighlight %}

That is all there is to it. Don't want your dlls to be locked? The easy solution
is to use another AppDomain with Shadow Copy.

**All the code for this blog post can be found in this [sample project][project] on my github.**

[issue]: https://github.com/NancyFx/Nancy/issues/2123
[appdomain]: https://msdn.microsoft.com/en-us/library/2bh4z9hs(v=vs.110).aspx
[project]: https://github.com/smaclell/NancyShadowAssemblies
