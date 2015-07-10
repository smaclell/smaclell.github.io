---
layout: post
title:  "Enforcing Mandatory Comments in C#"
date:   2015-07-10 00:47:07
tags: vs-studio project comments conventions
---

Making C# documentation mandatory for all public members is easy. Builds will
stop any code without standard comments dead in their tracks. Too much code
to update everything at once? You can selectively disable this option for code
you cannot fix yet. In an earlier [post][enforce] I mentioned you can make
comments mandatory and in this post I will show you how.

Why?
===============================================================================

Documentation is a great tool for helping people understand and navigate code.
The exterminator team I was a part of team has been really big on adding documentation lately. Anytime the team
encounters code new undocumented code or learns something new after debugging a
challenging problem they try to improve the documentation.

I don't like to think about coding standards. Mandatory comments are really easy to
enforce using the C# compiler. Let the tools do the work for you, so you can
focus on solving problems.

Enable the Project Setting
===============================================================================

The bottom of the build tab within your Visual Studio project settings has
everything you will need to enforce comments for all public members and types.
In order to enforce the setting do the following:

1. Enable XML documentation
2. Enable **Treat All Warnings As Errors** or **Specific Warnings with [1591][cs1591]**
3. Run a build to find missing comments

The screenshot below shows specifying the documentation warning to fail the build
and a failed build due to missing documentation:

<img src="/images/EnforcedComments.png" />

Updating the code
===============================================================================

If you are like me and are updating an existing codebase you probably have your
work cut out for you.

When I needed to do this I skipped updating documentation for some code I didn't know.
After updating hundreds of classes and methods I started to wear down. Rather
than write dumb boilerplate comments which did not help the code, I decided to leave it until the next time
we were working on that code.

You can use ``#pragma warning disable 1591`` and ``#pragma warning restore 1591``
to ignore missing comments and restore enforce missing comments, respectively.
If you want to ignore missing comments for an entire file place the
``#pragma warning disable 1591`` at the very top. The example below shows
ignoring and restoring the missing comment warnings.

{% highlight csharp tabsize=4 %}
using System;

namespace Example {

	/// <summary>This sample program greets friendly users!</summary>
	public static class Program {

		// Start ignoring methods which don't have comments
		#pragma warning disable 1591

		public static void Main() {
			Console.WriteLine( Message );
		}

		// Any additional lines past this point would have comments enforced
		#pragma warning restore 1591

		/// <summary>A common greeting among computers</summary>
		public const string Message = "Hello World";
	}

}
{% endhighlight %}

Enjoy
===============================================================================

So there you have it, enforcing comments for fun and profit. Enjoy!

[enforce]: /posts/exterminator-10-caught-by-conventions/#ext-10-note-1-reverse
[cs1591]: https://msdn.microsoft.com/en-us/library/zk18c1w9.aspx