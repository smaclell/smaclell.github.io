---
layout: post
title:  "Enforcing Public Comments in C#"
date:   2015-06-21 23:53:07
tags: vs-studio project
---

Making C# documentation mandatory for all public members is easy. Too much code
to update everything? You can selectively disable this option in areas which
you cannot update now.

Why?
===============================================================================

Documentation is a great tool for helping people understand and navigate code.
Our team has been really big on adding documentation lately. Anytime the team
encounters code new undocumented code or learns something new after debugging a
challenging problem we try to add to the documentation.

I don't like to about coding standards. Mandatory comments are really easy to
enforce using the C# compiler. Let the tools do the work for you, so you can
focus on solving problems.

Enable the Project Setting
===============================================================================

For my example of code with not enough comments I choose this Hello World:

{% highlight csharp %}
using System;

namespace Example {

	public static Program {

		public static void Main() {
			Console.WriteLine( "Hello World" );
		}

	}

}
{% endhighlight %}

1. Open the Project Settings

This is a freebie. Right click on your csproj file and select properties.

2. Go to the build tab

3. Enable Documentation Generation

Go to the build table

4. Enforce Comments


5. Profit.


Updating the code
===============================================================================

If you are like me and are updating an existing codebase you probably have your
work cut out for you.

When I needed to do this I skipped updating documentation for code I did't know.
After updating hundreds of classes and methods I started to wear down. Rather
than write dumb boilerplate comments, I decided to leave it to the person
working on that code.

{% highlight csharp %}
{% endhighlight %}


Bonus: CSC



C:\temp> "" > .\test.cs
C:\temp> "" >> .\test.cs
C:\temp> "namespace test {" >> .\test.cs
C:\temp> "" >> .\test.cs
C:\temp> "    }" >> .\test.cs
C:\temp> "" >> .\test.cs
C:\temp> "  }" >> .\test.cs
C:\temp> "" >> .\test.cs
C:\temp> "}" >> .\test.cs
>>> 
>>>

>>> "@ > .\test.cs
C:\temp> C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe E:\test.cs /out:e:\test.exe /doc /warn
aserror
Microsoft (R) Visual C# Compiler version 4.0.30319.33440
for Microsoft (R) .NET Framework 4.5
Copyright (C) Microsoft Corporation. All rights reserved.

fatal error CS2006: Command-line syntax error: Missing ':<text>' for '/doc' option
C:\Users\Scott.MacLellan>