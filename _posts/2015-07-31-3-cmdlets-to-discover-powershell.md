---
layout: post
title:  "3 Cmdlets to Discover PowerShell"
date:   2015-07-31 10:10:07
tags: powershell basics
---

Learning PowerShell can be really easy! With a few handy cmdlets you can teach
yourself enough PowerShell to get started. In this post I will teach you 3
essential cmdlets for learning PowerShell and discovering more.

I often find myself doing simple operations with services. Getting lists of
services, starting them, stopping them, etc. For my examples I will show off
the Service related cmdlets and objects. These are just examples and I would
encourage you to explore commands you use regularly or are interested in.

If this post is too long for you, try reading the [TL;DR][tldr] version on
TechNet by Microsoft.

Get-Command - Find Commands!
===============================================================================

There are thousands of different built-in commands for PowerShell. Finding what
you need is easy with ``Get-Command`` ([TechNet][get-command]). You can search for
commands by name, verb, noun or parameter to find the exact cmdlet you need.

Let's find all the commands:

{% highlight powershell %}
Get-Command 
{% endhighlight %}

<figure class="image-center">
	<img src="/images/posts/LearnPowerShell/GetCommand.PNG" alt="Output from 'Get-Command'" />
</figure>

Okay. That was too many. Let's use wildcards to narrow it down to just commands
for services:

{% highlight powershell %}
Get-Command *Service
{% endhighlight %}

<figure class="image-center">
	<img src="/images/posts/LearnPowerShell/GetCommandService.PNG" alt="Output from 'Get-Command *Service'" />
</figure>

Now we are getting somewhere! You can see the ``Get-Service``, ``Start-Service``
and ``Stop-Service`` cmdlets. Ok, now how do we use them?

Get-Help - How do I use a command?
===============================================================================

Learning how to use any command is easy with ``Get-Help`` ([TechNet][get-help]). The built-in
documentation shows all the parameters, examples and any additional notes.

Using ``Get-Help`` we can learn how to use ``Get-Service``:

{% highlight powershell %}
Get-Help Get-Service
{% endhighlight %}

<figure class="image-center">
	<img src="/images/posts/LearnPowerShell/GetServiceHelp.PNG" alt="Output from 'Get-Help Get-Service'" />
</figure>

What about a simple example of stopping a service?

{% highlight powershell %}
Get-Help Stop-Service -Examples
{% endhighlight %}

<figure class="image-center">
	<img src="/images/posts/LearnPowerShell/StopServiceExample.PNG" alt="Output from 'Get-Help Stop-Service -Examples'" />
</figure>

The PowerShell help also has meta topics like ``about_operators``. This can be
a great way to learn intricate details about PowerShell without ever leaving
your prompt. In this example I show how to review the built-in keywords
using ``Get-Help``.

{% highlight powershell %}
Get-Help about_Language_Keywords
{% endhighlight %}

<figure class="image-center">
	<img src="/images/posts/LearnPowerShell/GetHelpAbout.PNG" alt="Output from 'Get-Help about_Language_Keywords'" />
</figure>

Get-Member - What can an object do?
===============================================================================

Many commands, like ``Get-Service`` return objects you can interact with.
``Get-Member`` ([TechNet][get-member]) tells you exactly what methods and
properties any object has available.

In this example I show members returned on the objects from ``Get-Service``:

{% highlight powershell %}
$service = Get-Service PlugPlay
$service | Get-Member
{% endhighlight %}

<figure class="image-center">
	<img src="/images/posts/LearnPowerShell/GetMember.PNG" alt="Output equivalent to the output of 'Get-Service | Get-Member'" />
</figure>

Based on these methods I can also call ``$service.Stop()`` or ``$service.Start()``
instead of ``Stop-Service`` and ``Start-Service`` to stop/start services. Cool.


Get-PowerShell - Go Have Fun!
===============================================================================

I hope these basic cmdlets are helpful to you. I use them all the time to
find my way around and learn new commands/objects. These cmdlets were invaluable
to me when I first learned PowerShell.

Want more articles for learning PowerShell? Try [PowerShell.org][powershell] or
the links from these other blog posts:

* [The Best Ways to Learn PowerShell][learn]
* [Top 4 Resources for Learning and Experts to Watch][resources]

**UPDATE:** I have been listening to the [PowerScripting Podcast][podcast]
learning neat things coming up in Windows/PowerShell. In almost every podcast
they recommend [PowerShell in a Month of Lunches][lunches] by Don Jone's. I
have not watched any of these videos yet, but from the titles they look good.

Enjoy and happy discovering PowerShell.

<hr/>

*I would like to thank my lovely wife [Angela][ange] for helping review this
post. She was gracious enough to take time out of her vacation to find where
the apostrophes and dashes should go. Thanks dear, I love you.*

*I would also like to thank my son, Jude, for not smashing the keyboard.*

[tldr]: https://technet.microsoft.com/en-us/library/dd315275.aspx
[get-command]: https://technet.microsoft.com/en-us/library/ee176842.aspx
[get-help]: https://technet.microsoft.com/en-us/library/ee176848.aspx
[get-member]: https://technet.microsoft.com/en-us/library/ee176854.aspx
[powershell]: http://powershell.org/wp/
[learn]: http://blogs.technet.com/b/heyscriptingguy/archive/2015/01/04/weekend-scripter-the-best-ways-to-learn-powershell.aspx
[resources]: https://borntolearn.mslearn.net/b/weblog/archive/2015/04/07/powershell-top-4-resources-for-learning-and-experts-to-watch
[podcast]: http://powershell.org/wp/powerscripting-podcast/
[lunches]: https://www.youtube.com/playlist?list=PL6D474E721138865A
[ange]: http://macangela.tumblr.com
