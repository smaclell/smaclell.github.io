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

1. [Check the Windows Event Log](#core-sln-01)
2. [Checking the status of service/process](#core-sln-02)
3. [Watching performance counters](#core-sln-03)
4. [Managing Scheduled Tasks](#core-sln-04)
5. [Testing a server is isolation](#core-sln-05)
6. [Review files on the server](#core-sln-06)
7. [Configuring files on the server](#core-sln-07)
8. [Deploying new files](#core-sln-08)
9. [Recycle an Application Pool](#core-sln-09)
10. [Adjusting the Application Pools](#core-sln-10)

For the rest of the post I will break down how I would do each troubleshooting.

TODO: You might want to review powershell basics or my remoting trifecta
TODO: Mention powershell remoting

<div class="disclaimer">
<p>It was only my 3<sup>rd</sup> week using Server Core when I started writing this and my 2<sup>nd</sup> week was a vacation.
I am <em>not</em> an expert. I am however very enthusiastic and hoping to learn more.</p>
<p>If anything I have written here does not work, please add a comment.</p>
</div>

<span id="core-sln-01"></span>

## 1. Check the Windows Event Log

The easiest way to review the Event Log remotely is using MMC. Do the following:

1. On an extra computer open the Event Viewer
2. Right click on "Event Viewer (Local)"
3. Select "Connect to Another Computer"
4. Enter the computer name and credentials as needed
5. Profit

<figure class="image-center">
	<img src="/images/EventViewer.PNG" alt="Openning the connect to another computer dialog in Event Viewer" />
	<figcaption>Connecting to another computer using Event Viewer's MMC snapin</figcaption>
</figure>

Alternatively, you can use the PowerShell cmdlet ``Get-EventLog`` to view/filter messages.
This command can directly connect to remote servers and retrieve log messages.
There are additional parameters for further filtering such as ``Newest`` or ``Source``
which can show a limited number of new messages or only messages from a specific source,
respectively.

The following example shows how to gets the last ten Application event log
messages from the server BadServer.

{% highlight powershell %}
Get-EventLog -ComputerName BadServer -LogName Application -Newest 10
{% endhighlight %}

For more in-depth documentation from Microsoft review [Get-EventLog][get-eventlog-docs] or their
[examples][get-eventlog-examples].

<span id="core-sln-02"></span>

## 2. Checking the status of service/process

The easiest way to review/manage Services on a remote computer is using MMC.

1. On an extra computer open the Event Viewer
2. Right click on "Services (Local)"
3. Select "Connect to Another Computer"
4. Enter the computer name
5. Profit

<figure class="image-center">
	<img src="/images/Services.PNG" alt="Openning the connect to another computer dialog in Services" />
	<figcaption>Connecting to another computer using Services' MMC snapin</figcaption>
</figure>

If the command line is more your thing there are a number of great cmdlets and
tools you can use.

The most basic is ``sc.exe``. This is the swiss army knife of managing services.
It has commands for changing almost anything about a service. You can also dump
information about services and query to find exactly what you are looking for.
Below I show a number of examples for view services and modifying services on
the remote server BadServer.

{% highlight powershell %}
# Query all services running
sc.exe \\BadServer qc

# Query the WMSVC service
sc.exe \\BadServer qc WMSVC

# Stopping then starting WMSVC
# Warning: these commands are asynchronous
sc.exe \\BadServer stop WMSVC
sc.exe \\BadServer start WMSVC

# Configuring the W3SVC service to startup automatically with the OS
sc.exe \\BadServer config W3SVC start= auto
{% endhighlight %}

I prefer using the build in ``*-Service`` PowerShell commands.
 which can natively do remote operations.

However, this does not work for processes! I tried looking and could not find a
good way to view or manage remote processes. Have no fear PowerShell is here.

The Other Stuff
===============================================================================

Not everything is puppy dogs and rainbows. Some troubleshooting steps require
additional setup or different techniques. In this section I will show you
commands which can be run using ``Invoke-Command`` or ``Enter-PSSession`` to
manage iis, interact with files or perform local web requests.

### Managing IIS

I am going to show you how to use PowerShell commands to perform common operations.
Using the GUI tools requires additional configuration to be enabled which is not
required when you have such fantastic command line tools. If you still really want
to use a GUI I will show how to enable remote management at the [end of this section](#iis-remote).

First import the ``WebAdministration`` module installed with IIS.

{% highlight powershell %}
Import-Module WebAdministration
{% endhighlight %}

Then lets do a really simple example, reviewing a single binding on the 'CoolSite' web site:

{% highlight powershell %}
Get-WebBinding -Name 'CoolSite'
{% endhighlight %}

<span id="sln-9"></span>

Reviewing and restarting Application Pools is easy:

{% highlight powershell %}
# For looking up the list of application pools.
dir 'IIS:\AppPools\'

# Reviewing the active worker processes for the 'DefaultAppPool'
dir 'IIS:\AppPools\DefaultAppPool\WorkerProcesses\'

# Taking it further and looking at memory and CPU for the running worker processes
dir 'IIS:\AppPools\DefaultAppPool\WorkerProcesses\' | % {
	Get-Process -PID $_.processId
}

# Restarting an application pool
Restart-WebAppPool 'DefaultAppPool'
{% endhighlight %}

The entire ``WebAdministartion`` module is very useful for managing IIS. I
recommend you review the rest of the module commands:

{% highlight powershell %}
Get-Command -Module WebAdministration
{% endhighlight %}

To configure and review IIS settings I often use the ``appcmd`` tool. It is
complicated which is why I prefer using the PowerShell module.
Using ``appcmd`` takes getting used to. If you want to see what I mean read the
[appcmd introduction][intro] for an overview.

I had an AHA moment when I started understanding the configuration files used
by IIS. The primary files are the ``applicationHost.config`` for
server settings and ``web.config`` for individual applications. They are
XML documents and many of the commands act like filters or modifiers on the
elements. The syntax for these expressions is similar to other XML tools like XPath.

My favourite part about managing IIS is how well the configuration is
documented. On the IIS website, [www.iis.net][iis.net], you can find information
on every setting, what version they were added to and exactly how they work. The settings can be
configured using the xml configuration files directly (i.e. ``web.config``) or using
``appcmd``. For example here is the documentation for [application pools][pools]
and how to configure their [recycling][recycling] based on
[requests or memory limits][periodicRestart]. Wonderful!

<span id="sln-10"></span>

To demonstrate using ``appcmd`` this example configures the 'DefaultAppPool' to
recycle at a virtual memory limit of 100MB and a private memory limit of 200MB:

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

Since that looks very complicated I will break it down.

* By default ``appcmd`` is not in the path, which is why I am using the fully
qualified ``c:\Windows\system32\inetsrv\appcmd.exe`` to call the application.
* The specific command is indicated by ``set config``, because we want to set config. Duh.
* The ``-section:`` is used to declare where in the configuration to modify.
* We then use line 3 and 8 to change the appropriate setting to the right
value. The ``[name='DefaultAppPool']`` selects the application pool to change.
* Since application pools are configured for the entire server ``/commit:apphost``
is used to change the ``applicationHost.config`` which is for all server wide settings.

<span id="iis-remote"></span>

If you still want the GUI tools there is some additional configuration required.
There are [technet][technet] and [iis][iis] articles describing how this is done.
Alternatively, you can run this script (adapted from this
[orcsweb tutorial][orcsweb]) on the target server to enable remote configuration:

{% highlight powershell %}
# Installing the basic IIS and the management service
Install-WindowsFeature @( 'Web-Server', 'Web-Mgmt-Service' )

# Enable the remote management
Set-ItemProperty `
	-Path 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server' `
	-Name 'EnableRemoteManagement' `
	-Value 1

# Restart the management service so the setting can take effect
Restart-Service 'WMSVC'

# Profit.
{% endhighlight %}

### Files on the Server

Files on the server pose another challenge. Without being able to use explorer
how do you find your way around? How do you copy files over? How do you read files?

<span id="sln-6"></span>
<span id="sln-7"></span>
<span id="sln-8"></span>

The simplest way to read/write files on the target server is by creating a
network share. Here are some examples of creating and deleting shares with
different access:

{% highlight powershell %}
# Creating and deleting a readonly share for Administrators
New-SmbShare -Name 'readonly' -Path 'C:\inetpub' -ReadAccess 'Administrators'

# Creating and deleting a share with full access for Administrators
New-SmbShare -Name 'fullaccess' -Path 'C:\inetpub' -FullAccess 'Administrators'

# Removing both of the shares
Remove-SmbShare -Name 'readonly'
Remove-SmbShare -Name 'fullaccess'
{% endhighlight %}

For more examples review this [basics of SMB PowerShell][smb] blog post.

TODO: This fails miserably from a remote session.

What if you want to read files from another server? This is also fairly easy
using ``New-PSDrive`` or ``net use``. With this example I am creating the drive
Q to another network share.

{% highlight powershell %}
New-PSDrive -Name 'Q' -Root '\\network\share' -Credentials (Get-PSCredential)
{% endhighlight %}

### Local Requests

<span id="sln-5"></span>

Making local requests is harder. Much harder. Without a built in browser and
doing everything remotely pose a challenge.

You can however request different pages and direct them to local files to
review later:

{% highlight powershell %}
Invoke-WebRequest -Uri 'http://localhost/' -OutFile 'c:\response.txt'
{% endhighlight %}

If your website has specific bindings, you can add a local hostfile entry, make
the request and then remove the hostfile entry:

{% highlight powershell %}
$hostFile = 'C:\Windows\System32\drivers\etc\hosts'

# Add the host file you want to hit
$hostEntry = '127.0.0.1 testhost.com'
$hostEntry | Out-File $hostFile -Append -Encoding 'ASCII'

# Get the response like before, now with more host header!
Invoke-WebRequest -Uri 'http://testhost.com/' -OutFile 'c:\response.txt'

# Remove the host file you just added
$hostContents = Get-Content $hostFile
$hostContents | ? { $_ -notmatch 'testhost\.com' } | Out-File $hostFile -Encoding 'ASCII'
{% endhighlight %}

TODO: Complete this example.

A better option would be to use failed request tracing and use your extra
computer to make the request. This allows you to navigate the site normally
while still capturing the errors you are trying to troubleshoot.

Conclusion
===============================================================================

Troubleshooting Windows Server Core is different. You will need to use
different techniques, but can still get your job done. Good luck!

1. Check the Windows Event Log => [Use Event Viewer Remotely](#sln-1)
2. Checking the status of service/process => [Use Task Manager Remotely](#sln-2)
3. Watching performance counters => [Use PerfMon Remotely](#sln-3)
4. Managing Scheduled Tasks => [Use Scheduled Task Viewer Remotely](#sln-4)
5. Testing a server is isolation => [Make the request locally or use Failed Request Tracing](#sln-5)
6. Review files on the server => [Use network shares or PowerShell](#sln-6)
7. Configuring files on the server => [Use network shares](#sln-7)
8. Deploying new files => [Use network shares](#sln-8)
9. Recycle an Application Pool => [Use WebAdministration](#sln-9)
10. Adjusting the Application Pools => [Use AppCmd](#sln-10)

<hr />

*I would like to thank Stephen for the idea behind this post and the handy list
of reasons to login to a server.*

<hr />

<a id="notes-1-not-on-server-core-reverse" href="#notes-1-not-on-server-core">2.</a>
Perfmon had a wierd problem for me when I first tried to connect from my Windows 7 Desktop.
I needed to run [extra commands][perfmon-issue] to rebuild my perfmon settings.

<!-- http://serverfault.com/questions/468934/connecting-to-remote-server-using-performance-monitor-does-not-work -->
[get-eventlog-docs]: https://technet.microsoft.com/en-us/library/hh849834.aspx
[get-eventlog-examples]: https://technet.microsoft.com/en-ca/library/ee176846.aspx
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
[orcsweb]: http://www.orcsweb.com/blog/jamie-furr/manage-and-install-iis8-on-windows-2012-server-core/
[smb]: http://blogs.technet.com/b/josebda/archive/2012/06/27/the-basics-of-smb-powershell-a-feature-of-windows-server-2012-and-smb-3-0.aspx
[bastion-host]: https://en.wikipedia.org/wiki/Bastion_host
[perfmon-issue]: http://serverfault.com/questions/468934/connecting-to-remote-server-using-performance-monitor-does-not-work