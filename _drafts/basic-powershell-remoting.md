---
layout: post
title:  "Basic PowerShell Remoting"
date:   2015-11-01 23:45:07
description: "A simple overview of Enter-PSSession and Invoke-Command."
tags: windows server-core remoting
image:
  feature: https://farm8.staticflickr.com/7496/16031914875_0e7bd8fb4a_b.jpg
  credit: "Marine Bay Sands from the Gardens by the Bay, Singapore by John Sonderman - CC BY NC 2.0"
  creditlink: https://www.flickr.com/photos/johnsonderman/16031914875/
---

Using remote PowerShell commands is a great way to manage servers.
I have been spending more time using Windows 2012 Server Core which makes using
remote tools essential. Instead of connecting using Remote Desktop, I try to do
everything using PowerShell remotely. In this post, I will show off some
extremely basic remote PowerShell commands, ``Enter-PSSession`` and
``Invoke-Command``.

Let's start with a simple command:

{% highlight powershell %}
Enter-PSSession -ComputerName 'Target'
{% endhighlight %}

This amazing command uses your current PowerShell prompt to run PowerShell
commands interactively on the remote computer, "Target". When you
are done type ``exit``. With this command you now have the complete
might of a fully operational PowerShell!

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
and will still stream results back to your current prompt. This is great for
one line commands like restarting IIS on the remote server "Target":

{% highlight powershell %}
Invoke-Command -ComputerName 'Target' -ScriptBlock { iisreset }
{% endhighlight %}

Remote commands are allowed by default on Windows Server 2012 and beyond.
On older operating systems you can run ``Enabled-PSRemoting -Force`` from
an Administrator PowerShell prompt on the target machine to enable remoting. You can
then test the connection by running the following from another computer:

{% highlight powershell %}
Invoke-Command -ComputerName 'Target' -ScriptBlock { echo 'hello' }
{% endhighlight %}

There are many other commands which natively support remote operations.
These commands will often have a ``ComputerName`` parameter. You can see a list
of commands with the ``ComputerName`` parameter by using:

{% highlight powershell %}
Get-Command -ParameterName 'ComputerName'
{% endhighlight %}

Among my favourites is ``Get-EventLog``. It is a great way to look at messages
from a remote server without ever leaving the terminal. This example
retrieves, formats and displays the last 5 error messages from the remote
server "Target":

{% highlight powershell %}
Get-EventLog -ComputerName 'Target' -LogName 'Application' -Newest 5 -EntryType 'Error' `
	| Format-List TimeWritten, Message `
	| more
{% endhighlight %}

I hope you liked this mini intro to PowerShell remoting.
Now go run some commands!
