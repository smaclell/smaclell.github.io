---
layout: post
title:  "10 Debugging Steps Without Being On The Server (Core)"
date:   2015-07-24 01:19:07
tags: windows server-core troubleshooting
image:
  feature: FixingServers.jpg
  credit: "QFamily - Day 83: Fixing Servers - CC BY 2.0 (resized and compressed)"
  creditlink: https://www.flickr.com/photos/dasqfamily/1142424516/
---

I am trying to help some teams use Server Core on Windows 2012 R2. In case you
are not familiar with Server Core there is almost no GUI. It is amazing!
However, for troubleshooting and investigating problems you might be lost at
first. Using remote desktop and debugging on the server is a thing of the past.
In this post I will show you how to do some common tasks to help you get started.

My coworker, Stephen, sent me a list of common troubleshooting people do
directly on servers:

1. Check the Windows Event Log
2. Checking the status of service/process
3. Watching performance counters
4. Managing Scheduled Tasks
5. Testing a server is isolation
6. Review files on the server
7. Configuring files on the server
8. Deploying new files
9. Recycle an Application Pool
10. Adjusting the Application Pools

<div class="disclaimer">
<p>This my 3<sup>rd</sup> week using Server Core and my 2<sup>nd</sup> week was a vacation.
I am <em>not</em> an expert. I am however very enthusiastic and hoping to learn more.</p>
<p>If anything I have written here does not work, please add a comment.</p>
</div>

The Remoting Trifecta
===============================================================================

I think there are the major techniques you can use to do most troubleshooting.
The first step is to perform the steps remotely that you would have done
locally. I typically use the following three methods to do remoting:

* Using a Jump Box
* Connect to another computer with MMC
* PowerShell Remoting

### Using a Jump Box

A "Jump Box" is another computer you Remote Desktop into so you can perform
your remote operations. The trick here is then using the other remote options,
connecting via MMC and PowerShell Remoting, from the "Jump Box" to do your
actual work.

Unlike the actual servers you are debugging I would install more of the GUI
components onto the "Jump Box". I would create a few "Jump Boxes" for regular
use. While they may not be as efficient or easy to patch/maintain as the
Servers running Server Core they are much more convenient. If there are only a
few of them you are still being very efficient overall.

"Jump Boxes" can be a security risk. If they are a hop skip and a jump away
from all your servers they will definitely be potential attack vector. Be
careful in how you secure your server.

TODO: Talk more about the security of jump boxes.

### Connecting via MMC

The Microsoft Management Console (MMC) has been around for a long time. You can
use this versatile tool to administer other computers. Around half of the items
from the troubleshooting list can be done this way.

1. On second computer or "Jump Box" open the particular tool you are interested
in, i.e. Event Viewer.
2. Right click on the tool name or first item.
3. Select "Connect to Another Computer".
4. Enter the computer name and credentials as needed.
5. Profit

<figure class="image-center">
	<img src="/images/EventViewer.PNG" alt="Openning the connect to another computer dialog in Event Viewer" />
	<figcaption>Connecting to another computer using Event Viewer's MMC snapin</figcaption>
</figure>

### PowerShell Remoting

Using more PowerShell Remoting has changed how I manage computers. Instead of
connecting directly to the box I try to remotely connect using PowerShell.
Using these techniques you can run any command. If you have never used PowerShell
before I strongly encourage you to learn [Get-Command, Get-Help and Get-Member][learn-ps].

Lets start with this simple command:

{% highlight powershell %}
Enter-PSSession -ComputerName Target
{% endhighlight %}

This amazing command lets uses your current PowerShell prompt to run PowerShell
commands on the remote computer. This is great for interactive tasks or trying
out different options. You now have the complete might of a full operational
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

TODO: Talk about security and enabling remoting.

If you want to run a single command remotely you can also use
``Invoke-Command``. Unlike ``Enter-PSSession``, this will only run the initial
command you provide then stop. All the results will be sent back to your
current prompt. Here is an example of restarting IIS on a remote server:

{% highlight powershell %}
Invoke-Command -ComputerName Target -ScriptBlock { iisreset }
{% endhighlight %}

There are many other commands which can automatically do simple remote
operations. These commands will often have a ``ComputerName`` parameter
(you can see a whole list using ``Get-Command -ParameterName ComputerName``).

Among my favourites is ``Get-EventLog``. It is a great way to look at messages
for a remote server without ever leaving the terminal. Here is an example of
retrieving the last 5 error messages and formatting them:

{% highlight powershell %}
Get-EventLog Application -Newest 5 -EntryType Error `
	| Format-List TimeWritten, Message `
	| more
{% endhighlight %}

The Other Stuff
===============================================================================



### Managing IIS

IIS Requires extra setup.

TODO: Learn how to properly setup remote management.
TODO: Show the powershell commands with WebAdministration

### Files on the Server

### Local Requests

Making local requests is harder. Much harder. There is no browser.

it is really hard.  For most
people


<hr />

I would like to thank Stephen for the idea behind this post and the handy list
of reasons to login to a server.

<!-- http://serverfault.com/questions/468934/connecting-to-remote-server-using-performance-monitor-does-not-work -->
[jump]: https://en.wikipedia.org/wiki/Jump_server
[jump-security]: http://www.infoworld.com/article/2612700/security/-jump-boxes--improve-security--if-you-set-them-up-right.html?page=1
[learn-ps]: {% post_url 2015-07-31-3-cmdlets-to-discover-powershell %}