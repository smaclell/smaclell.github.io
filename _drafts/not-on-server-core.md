---
layout: post
title:  "10 Debugging Steps Without Being On The Server (Core)"
date:   2015-07-24 01:19:07
tags: windows server-core troubleshooting stephen
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

* Using another Computer
* Connect to another computer with MMC
* PowerShell Remoting

### Using another Computer

It is starts with being on a different computer than the one you are
troubleshooting. From this second computer you can then connect to the server
you are troubleshooting using MMC, PowerShell Remoting, or other remote tools.

This second computer could be anything from your desktop, another server in the
data center/cloud or a locked down "Jump Box"<sup id="notes-1-not-on-server-core-reverse"><a href="#notes-1-not-on-server-core">1</a></sup>. The key is ensuring
the other computer you are going to use can remotely connect to the machine you
want to investigate. This means jumping through whatever networking and
authentication hoops you need.

### Connecting via MMC

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

### PowerShell Remoting

Using more PowerShell Remoting has changed how I manage computers. Instead of
connecting directly to the box using Remote Desktop I will now try to do everything using PowerShell remotely.
Using these techniques you can run any command. If you have never used PowerShell
before I strongly encourage you to learn [Get-Command, Get-Help and Get-Member][learn-ps].

Lets start with this simple command:

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

If you want to run a single command remotely you can also use
``Invoke-Command``. Unlike ``Enter-PSSession``, this will run the commands you
provide then immediately stop. All the results will be sent back to your
current prompt. Here is an example of restarting IIS on the remote server "Target":

{% highlight powershell %}
Invoke-Command -ComputerName Target -ScriptBlock { iisreset }
{% endhighlight %}

The remote commands are allowed by default on Windows Server 2012 and beyond.
On only operating systems you will need to do some configuration prior to
being able to run these commands. The easiest thing to do is run
``Enabled-PSRemoting -Force`` from an Administrator PowerShell prompt. You can
then test the connection by running ``Invoke-Command -ComputerName Target -ScriptBlock { echo hello }``.

There are many other commands which natively support remote operations.
These commands will often have a ``ComputerName`` parameter
(you can see a whole list using ``Get-Command -ParameterName ComputerName``).

Among my favourites is ``Get-EventLog``. It is a great way to look at messages
for a remote server without ever leaving the terminal. This example
retrieves, formats and displays the last 5 error messages:

{% highlight powershell %}
Get-EventLog Application -Newest 5 -EntryType Error `
	| Format-List TimeWritten, Message `
	| more
{% endhighlight %}

The Other Stuff
===============================================================================

Some of the troubleshooting is harder or requires additional setup or techniques.

### Managing IIS

The GUI Tools require additional setup to configure. I cannot remember setting
this up before. There are [technet][technet] and [iis][iis] articles describing
how this is done.

Instead of using the GUI Tools I am going to show you how to use PowerShell
commands to perform common operations.

{% highlight powershell %}
Import-Module WebAdministration

# For a list of commands run:
# Get-Command -Module WebAdministration
{% endhighlight %}

Lets start with a really simple example, reviewing a single binding on a fake site:

{% highlight powershell %}
Get-WebBinding -Name 'WebSiteName'
{% endhighlight %}

Since my coworkers were very interested in Application Pools here are some
examples:

{% highlight powershell %}
# For looking up the list of application pools.
dir 'IIS:\AppPools\'

# Reviewing the active worker processes for the 'DefaultAppPool'
dir 'IIS:\AppPools\DefaultAppPool\WorkerProcesses\'

# Taking it further and looking at the running worker processes more closely
dir 'IIS:\AppPools\DefaultAppPool\WorkerProcesses\' | % {
	Get-Process -PID $_.processId
}

# Restarting an application pool
Restart-WebAppPool 'DefaultAppPool'
{% endhighlight %}

These commands are extremely powerful and I recommend you review what is
available from the ``WebAdministartion`` module.

Another powerful tool for administering IIS is ``appcmd``. I have to admit I
don't often use it because I find it is pretty complicated. Where I do prefer
``appcmd`` is when reviewing/modifying settings of a website/application pool.
Using the tool can take a bit getting of learning. You might want to read the
[introduction][intro] for ``appcmd`` to see exactly what I mean.

I find it really helps me understand the tool by thinking of the underlying
configuration files. The primary files are the ``applicationHost.config`` for
the server level and ``web.config`` for individual applications. They are
standard XML and many of the commands act like filters or modifiers on the
elements in either of these documents. The syntax for these expressions feels
like XPath.

Probably my favourite part about managing IIS is how well the configuration is
documented. On the IIS website, [www.iis.net][iis.net], you can find information
on every setting, what version they were added to and exactly how they work. The settings typically
work with either the xml configuration files directly (i.e. ``web.config``) or using
``appcmd``. For example here is the documentation for [application pools][pools]
and how to configure their [recycling][recycling] based on
[requests or memory limits][periodicRestart]. Wonderful! 

Here is a more in-depth example using ``appcmd`` to configure the
'DefaultAppPool' to recycle at the virtual memory limit of 100MB and the
private memory limit of 200MB:

{% highlight batch linenos %}
C:\Windows\system32\inetsrv\appcmd.exe set config `
	-section:system.applicationHost/applicationPools `
	/"[name='DefaultAppPool'].recycling.periodicRestart.memory:102400" `
	/commit:apphost

C:\Windows\system32\inetsrv\appcmd.exe set config `
	-section:system.applicationHost/applicationPools `
	/"[name='DefaultAppPool'].recycling.periodicRestart.privateMemory:204800" `
	/commit:apphost
{% endhighlight %}

That was a mouthful so let me break it down.

1. By default ``appcmd`` is not in the path, which is why I am using the fully
qualified ``c:\Windows\system32\inetsrv\appcmd.exe`` to call the application.
2. The specific command is indicated by ``set config``, because we want to set config. Duh.
3. The ``section`` is used to say exactly where in the configuration to apply the
new settings.
4. We then use line 3 and 8 to change the appropriate setting to the right
value. The odd ``[name='DefaultAppPool']`` is used to select the application
pool to change.
5. Finally because application pools are a server wide setting
they belong in the ``apphost`` and need ``/commit:apphost`` to be configured
correctly.

### Files on the Server

Files on the server pose another challenge. Without being able to run explorer
how do you find your way around? How do you copy files over? How do you read files?

The simplest way to read/write files on the target server is by creating a
network share. Here are some examples of creating and deleting shares with
different access:

{% highlight powershell %}
# Creating and deleting a readonly share for Administrators
New-SmbShare -Name 'readonly' -Path 'C:\inetpub' -ReadAccess 'Administrators'
Remove-SmbShare -Name 'readonly'

# Creating and deleting a share with full access for Administrators
New-SmbShare -Name 'fullaccess' -Path 'C:\inetpub' -FullAccess 'Administrators'
Remove-SmbShare -Name 'fullaccess'
{% endhighlight %}

For more examples review this [basics of SMB PowerShell][smb] blog post.

What if you want to read files from another server? This is also fairly easy
using ``New-PSDrive`` or ``net use``. With this example I am creating the drive
Q to another network share.

TODO: This fails miserably from a remote session.

{% highlight powershell %}
New-PSDrive -Name 'Q' -Root '\\network\share' -Credentials (Get-PSCredential)
{% endhighlight %}

### Local Requests

Making local requests is harder. Much harder. There is no browser.

Instead we will use PowerShell to configure the a host file entry, request the
page you want and then remove the host file entry.

This is not a great way to debug, but you wanted a way to do this. This only works
for really simple requests and is probably useless if what you need to do is more
complicated, like logging in to the site and navigating around.

When I was configuring my first Server Core machine I ran into a configuration
problem and needed to do something like this. Instead, I cheated and ran the
test on a machine with a full UI. My problem turned out to be a bad web.config.

<hr />

*I would like to thank Stephen for the idea behind this post and the handy list
of reasons to login to a server.*

<hr />

<a id="notes-1-not-on-server-core-reverse" href="#notes-1-not-on-server-core">1.</a> In writing this post I learnt that a "[Jump Box][jump]" is a special concept.
It is a [Bastion Host][bastion-host] which is a server which has been highly locked (via access, networking) and hardened to withstand attacks.
They sound neat and talking to a few security guys both scared me. Security is important and so don't mess around.
If you think you need one I would strongly encourage you to go learn more about them.

<!-- http://serverfault.com/questions/468934/connecting-to-remote-server-using-performance-monitor-does-not-work -->
[jump]: https://en.wikipedia.org/wiki/Jump_server
[jump-security]: http://www.infoworld.com/article/2612700/security/-jump-boxes--improve-security--if-you-set-them-up-right.html?page=1
[learn-ps]: {% post_url 2015-07-31-3-cmdlets-to-discover-powershell %}
[technet]: https://technet.microsoft.com/en-us/magazine/dn198619.aspx
[iis]: https://www.iis.net/learn/install/installing-iis-85/installing-iis-85-on-windows-server-2012-r2
[iis.net]: https://www.iis.net
[intro]: https://www.iis.net/learn/get-started/getting-started-with-iis/getting-started-with-appcmdexe
[pools]: https://www.iis.net/configreference/system.applicationhost/applicationpools
[recycling]: https://www.iis.net/configreference/system.applicationhost/applicationpools/add/recycling
[periodicRestart]: https://www.iis.net/configreference/system.applicationhost/applicationpools/add/recycling/periodicrestart
[smb]: http://blogs.technet.com/b/josebda/archive/2012/06/27/the-basics-of-smb-powershell-a-feature-of-windows-server-2012-and-smb-3-0.aspx
[bastion-host]: https://en.wikipedia.org/wiki/Bastion_host
