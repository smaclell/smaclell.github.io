---
layout: post
title:  "The Windows Server Remote Trifecta"
date:   2015-07-24 01:19:07
tags: windows server-core remoting
image:
  feature: https://farm8.staticflickr.com/7496/16031914875_0e7bd8fb4a_b.jpg
  credit: "Marine Bay Sands from the Gardens by the Bay, Singapore by John Sonderman - CC BY NC 2.0"
  creditlink: https://www.flickr.com/photos/johnsonderman/16031914875/
---

Troubleshooting boxes using only remote tools is a challenge. Troubleshooting a
Windows server without any GUI makes it event more fun. Lately, I have been debugging
new Windows Server 2012 servers which are running Server Core. The normal point
and click adventure of debugging Windows is not possible. This blog post is to
share three ways I have been trying to remotely troubleshoot our servers
without using an RDP session.

<div class="disclaimer">
<p>It was only my 3<sup>rd</sup> week using Server Core when I started writing this and my 2<sup>nd</sup> week was a vacation.
I am <em>not</em> an expert. I am however very enthusiastic and hoping to learn more.</p>
<p>If anything I have written here does not work, please add a comment.</p>
</div>

I think there are three major techniques you can use to start most remote
troubleshooting. The first step is to perform the steps remotely that you would have done
locally. I typically use the following three methods to do remoting:

* Using another Computer
* Connect to remotely with MMC
* PowerShell Remoting

TODO: Review RSAT capabilities
http://searchwindowsserver.techtarget.com/tip/Multiserver-administration-and-more-with-RSAT-in-Windows-Server-2012
http://searchwindowsserver.techtarget.com/definition/RSAT-Microsoft-Remote-Server-Administration-Tools

Using another Computer
===============================================================================

All of the troubleshooting starts with using a different computer.
From this second computer you can then connect to the server
you are troubleshooting using MMC, PowerShell Remoting, or other remote tools.

This second computer could be anything from your desktop, another server in the
data center/cloud or a locked down "Jump Box"<sup id="notes-1-remote trifecta-reverse"><a href="#notes-1-remote-trifecta">1</a></sup>. The key is ensuring
the other computer you are going to use can remotely connect to the machine you
want to investigate. This means jumping through whatever networking and
authentication hoops you need.

If you connected directly to a Server Core computer you want to troubleshoot you won't be
able to do much. Not having a UI will make it harder unless you want to only
use the commandline tools. I would still recommend against it since using remote
PowerShell is very good and simpler than potentially using nested RDP sessions.

Connecting via MMC
===============================================================================

The Microsoft Management Console (MMC) has been around for a long time. You can
use this versatile tool to administer other computers. Around half of the items
from the troubleshooting list can be done through MMC.

Here is the process for Event Viewer, Performance Counters and probably many more:

1. On the extra computer open the particular tool you want to use, i.e. Event Viewer
2. Right click on the tool name or first item
3. Select "Connect to Another Computer"
4. Enter the computer name and credentials as needed
5. Profit

<figure class="image-center">
	<img src="/images/EventViewer.PNG" alt="Openning the connect to another computer dialog in Event Viewer" />
	<figcaption>Connecting to another computer using Event Viewer's MMC snapin</figcaption>
</figure>


TODO: Review this list of tools.
* PerfMon, needs counters added per machine
* Scheduled Tasks seems to be failing due to wierd .NET exceptions. Try with a full GUI 2012
* Event Viewer is fine
* Services is fine
* Cannot do Task Manager or Resource Monitor

I have tried this exact same process the following tools which
for the other tools Stephen mentioned (perfmon, scheduled tasks, services, task manager) and the
process is exactly the same.

PowerShell Remoting
===============================================================================

Using PowerShell Remoting has changed how I manage other computers. Instead of
connecting using Remote Desktop I try to do everything using PowerShell remotely.
In this section I am going to show you some techniques for running any command remotely.
If you have never used PowerShell
before I strongly encourage you to learn [Get-Command, Get-Help and Get-Member][learn-ps].

Lets start with a simple command:

{% highlight powershell %}
Enter-PSSession -ComputerName Target
{% endhighlight %}

This amazing command lets uses your current PowerShell prompt to run PowerShell
commands on the remote computer "Target". This is great for interactive tasks or
experimenting. You now have the complete might of a fully operational
PowerShell at your fingers!

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

You can run batches or single commands using
``Invoke-Command`` without the interactive shell like ``Enter-PSSession``. ``Invoke-Command`` will run the commands you
provide and return the results back to your current prompt. This is great for one line commands like restarting IIS on the remote server "Target":

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

<hr />

<a id="notes-1-remote-trifecta" href="#notes-1-remote-trifecta-reverse">1.</a> In writing this post I learnt that a "[Jump Box][jump]" is a special concept.
It is a [Bastion Host][bastion-host] which is a server which has been highly locked (via access, networking) and hardened to withstand attacks.
They sound neat and talking to a few security guys both scared me. Security is important and so don't mess around.
If you think you need one, you probably do and I would strongly encourage you to go learn more about them.