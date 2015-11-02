---
layout: post
title:  "The Windows Server Remote Trifecta"
date:   2015-07-24 01:19:07
description: "A simple overview of Enter-PSSession and Invoke-Command."
tags: windows server-core remoting
image:
  feature: https://farm8.staticflickr.com/7496/16031914875_0e7bd8fb4a_b.jpg
  credit: "Marine Bay Sands from the Gardens by the Bay, Singapore by John Sonderman - CC BY NC 2.0"
  creditlink: https://www.flickr.com/photos/johnsonderman/16031914875/
---

Using remote PowerShell commands is a great way to remotely manage servers.
I have been spending more time using Windows 2012 Server Core which makes using
remote tools essential. In this post I will show off some extremely basic remote
PowerShell commands, ``Enter-PSSession`` and ``Invoke-Command``.

Using PowerShell Remoting has changed how I manage other computers. Instead of
connecting using Remote Desktop I try to do everything using PowerShell remotely.
I am going to show you some techniques for running commands remotely.

Shameless plug: if you have never used PowerShell before I strongly encourage
you to learn [Get-Command, Get-Help and Get-Member][learn-ps] before getting
started.

Lets start with a simple command:

{% highlight powershell %}
Enter-PSSession -ComputerName Target
{% endhighlight %}

This amazing command lets uses your current PowerShell prompt to run PowerShell
commands on the remote computer "Target" interactively. You can run one command
after another on the remote server just like how you would locally. When you
are done type ``exit``. With this command you now have the complete
might of a fully operational PowerShell at your fingers!

<figure class="image-center">
	<a href="https://commons.wikimedia.org/wiki/File%3ALong_Beach_Comic_Expo_2011_-_Darth_Vader_and_his_stormtroopers_(5648076179).jpg">
		<img
			width="480"
			alt="Long Beach Comic Expo 2011 - Darth Vader and his stormtroopers (5648076179)"
			src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Long_Beach_Comic_Expo_2011_-_Darth_Vader_and_his_stormtroopers_%285648076179%29.jpg/640px-Long_Beach_Comic_Expo_2011_-_Darth_Vader_and_his_stormtroopers_%285648076179%29.jpg"
			/>
	</a>
	<figcaption>
		By <a href="http://www.flickr.com/people/26728047@N05">The Conmunity - Pop Culture Geek</a> from Los Angeles, CA, USA <a rel="nofollow" href="http://creativecommons.org/licenses/by/2.0">CC BY 2.0</a>, via Wikimedia Commons
	</figcaption>
</figure>
<!-- https://www.flickr.com/photos/elaws/3775252224 -->

You can run single or multiple commands using
``Invoke-Command``. Unlike ``Enter-PSSession``, this command is not interactive
and will only run what you give it. Again results will be returned to your
current prompt. This is great for one line commands like restarting IIS on the
remote server "Target":

{% highlight powershell %}
Invoke-Command -ComputerName Target -ScriptBlock { iisreset }
{% endhighlight %}

Remote commands are allowed by default on Windows Server 2012 and beyond.
On older operating systems you can run ``Enabled-PSRemoting -Force`` from
an Administrator PowerShell prompt on the target machine to enable remoting. You can
then test the connection by running ``Invoke-Command -ComputerName Target -ScriptBlock { echo hello }`` from another computer.

There are many other commands which natively support remote operations.
These commands will often have a ``ComputerName`` parameter
(you can see a whole list using ``Get-Command -ParameterName ComputerName``).

Among my favourites is ``Get-EventLog``. It is a great way to look at messages
from a remote server without ever leaving the terminal. This example
retrieves, formats and displays the last 5 error messages:

{% highlight powershell %}
Get-EventLog Application -Newest 5 -EntryType Error `
	| Format-List TimeWritten, Message `
	| more
{% endhighlight %}

I hope you liked this mini intro to PowerShell remoting.


[learn-ps]: {% post_url 2015-07-31-3-cmdlets-to-discover-powershell %}
