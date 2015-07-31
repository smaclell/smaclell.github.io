---
layout: post
title:  "3 Cmdlets to Discover PowerShell"
date:   2015-07-30 23:42:07
tags: powershell basics
---

Learning PowerShell can be really easy! With a few handy commands you can teach
yourself enough PowerShell to get started. In this post I will teach you 3
essential commands for learning PowerShell and discovering more.

I often find myself doing simple operations with services. Getting lists of
services, starting them, stopping them, etc. For my examples I will show off
the Service related cmdlets and objects. These are just examples and I would
encourage you to explore commands you use regularly or are interested in.

If this post is too long for you, try reading the [TL;DR][tldr] version on
TechNet by Microsoft.

Get-Command - Find Commands!
===============================================================================

There are thousands of different built in commands for PowerShell. Finding what
you need is easy with ``Get-Command`` ([TechNet][get-command]). You can search for
commands by name, verb, noun or parameter to find the exact cmdlet you need.

Lets find all the commands:

{% highlight powershell %}
Get-Command 
{% endhighlight %}

Okay. That was too many. Let's use wildcards to narrow it down to just commands
for services:

{% highlight powershell %}
Get-Command *Service
{% endhighlight %}

Now we are getting somewhere! You can see the ``Get-Service``, ``Start-Service``
and ``Stop-Service`` cmdlets. Umm, how do we use them?

Get-Help - How do I use a command?
===============================================================================

Learning how to use any command is easy with ``Get-Help`` ([TechNet][get-help]). The built in
documentation shows all the parameters, examples and any additional notes.

Using ``Get-Help`` we can see how to learn how to use ``Get-Service``.

{% highlight powershell %}
Get-Help Get-Service
{% endhighlight %}

What about a simple example of stopping a service?

{% highlight powershell %}
Get-Help Stop-Service -Examples
{% endhighlight %}

The PowerShell help also has meta topics like ``about_operators``. This can be
a great way to learn more a intricate details about PowerShell or skip a simple
google search. In this example you can learn all about the many keywords in the
language with snippets showing how they are used.

{% highlight powershell %}
Get-Help about_Language_Keywords
{% endhighlight %}

Get-Member - What can an object do?
===============================================================================

Many commands, like ``Get-Service`` return objects you can interact with.
``Get-Member`` ([TechNet][get-member])tells you exactly what each objects can do and all of their properties.

In this example I show members returned on the objects from ``Get-Service``:

{% highlight powershell %}
$service = Get-Service PlugPlay
$service | Get-Member
{% endhighlight %}

Based on these methods I can also call ``$service.Stop()`` or ``$service.Start()``
instead of ``Stop-Service`` and ``Start-Service`` to start/stop services. Cool.


Get-PowerShell - Go Have Fun!
===============================================================================

I hope these basic commands are helpful for you. I use them all the time to
find my way around and learn new commands/objects. These commands were invaluable
to me when I first learnt PowerShell.

Want more articles for learning PowerShell? Try the links from these other blog
posts:

* [PowerShell.org][powershell]
* [The Best Ways to Learn PowerShell][learn]
* [Top 4 Resources for Learning and Experts to Watch][resources]

Try finding a new command and learning about it. Enjoy.

[tldr]: https://technet.microsoft.com/en-us/library/dd315275.aspx
[get-command]: https://technet.microsoft.com/en-us/library/ee176842.aspx
[get-help]: https://technet.microsoft.com/en-us/library/ee176848.aspx
[get-member]: https://technet.microsoft.com/en-us/library/ee176854.aspx
[powershell]: http://powershell.org/wp/
[learn]: http://blogs.technet.com/b/heyscriptingguy/archive/2015/01/04/weekend-scripter-the-best-ways-to-learn-powershell.aspx
[resources]: https://borntolearn.mslearn.net/b/weblog/archive/2015/04/07/powershell-top-4-resources-for-learning-and-experts-to-watch
