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

The easiest way to review the Event Log is by connecting a local Event Viewer GUI to the remote server. Do the following:

1. On an extra computer open the Event Viewer
2. Right click on "Event Viewer (Local)"
3. Select "Connect to Another Computer"
4. Enter the computer name and credentials as needed
5. Profit

<figure class="image-center">
	<img src="/images/EventViewer.PNG" alt="Opening the connect to another computer dialog in Event Viewer" />
	<figcaption>Connecting to another computer's Event Log using Event Viewer</figcaption>
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

The easiest way to review/manage Services on a remote computer is connecting
your local Services GUI to the remote server.

1. On an extra computer open the Services tool
2. Right click on "Services (Local)"
3. Select "Connect to Another Computer"
4. Enter the computer name
5. Profit

<figure class="image-center">
	<img src="/images/Services.PNG" alt="Opening the connect to another computer dialog in Services" />
	<figcaption>Connecting to another computer to manage Services</figcaption>
</figure>

If the command line is more your thing there are a number of great cmdlets and
tools you can use.

The most comprehensive is ``sc.exe``. This is the swiss army knife of managing services.
It has commands for changing any service configuration. You can also print
information about services and query the services to find exactly what you are looking for.

Shown below are examples for viewing and modifying services on the remote server
BadServer.

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

I prefer using the built in ``*-Service`` PowerShell commands. They are simpler
and return objects which are easier to use. One drawback is the configuration
changes which can be made are limited. You cannot change advanced settings like
delays between retries or required services. Some of the commands also need to
be run using PowerShell Remoting.

Here is the equivalent operations as the ``sc.exe`` above:

{% highlight powershell %}
# Query all services running
Get-Service -ComputerName BadServer

# Query the WMSVC service
Get-Service -Name WMSVC -ComputerName BadServer

# Stopping then starting WMSVC
# Warning: Unlike sc.exe these commands are synchronous and need PowerShell Remoting
Invoke-Command -ComputerName BadServer -ScriptBlock {
	Stop-Service WMSVC
	Start-Service WMSVC
}

# Configuring the W3SVC service to startup automatically with the OS
Set-Service -Name W3SVC -ComputerName BadServer -StartupType Automatic

# This will display additional service commands you can use
Get-Command -Noun Service
{% endhighlight %}

For processes it is a different story. I was not able to find a good way to
view or manage remote processes. Have no fear PowerShell is here. Like the
``*-Service`` commands there are equivalent ``*-Process`` commands. These
commands may also need to be run using PowerShell Remoting.

This simple example will list the running processes on BadServer and try to
stop 'notepad':

{% highlight powershell %}
# Get all the running processes
Get-Process -ComputerName BadServer

# Get the notepad process
Get-Process -Name notepad -ComputerName BadServer

# Stopping notepad using Powershell Remoting
Invoke-Command -ComputerName BadServer -ScriptBlock {
	Stop-Process notepad
}

# This will display additional process commands you can use
Get-Command -Noun Process
{% endhighlight %}

<span id="core-sln-03"></span>

## 3. Watching performance counters

GUI

typeperf

Get-Counter and Get-Counter -Continuous

<span id="core-sln-04"></span>

## 4. Managing Scheduled Tasks

Tasks GUI
Warning of 2012 to 2012.

schtasks basics

<span id="core-sln-05"></span>

## 5. Testing a server is isolation

Host file entry to hit that server.

Curl approach.

Failed Request Tracing.

<span id="core-sln-06"></span>

## 6. Review files on the server

To review files using Windows Explorer you can use PowerShell to create a
readonly file share on the remote server. It is easy to restrict the file share
permissions so only you can view the content. Even better you can remove the
file share when you are are done debugging to prevent others from using it.

Here is how you create a readonly file share for Administrators on BadServer:

{% highlight powershell %}
Invoke-Commmand -ComputerName 'BadServer' -ScriptBlock {
    New-SmbShare -Name 'readonly' -Path 'C:\inetpub' -ReadAccess 'Administrators'
}
{% endhighlight %}

By default the file share will continue to be availible after reboots. You can use
the ``-Temporary`` parameter which will remove the file share after a reboot. It is
better to explicitly remove the file share using the following command:

{% highlight powershell %}
Invoke-Commmand -ComputerName 'BadServer' -ScriptBlock {
    Remove-SmbShare -Name 'readonly'
}
{% endhighlight %}

Another great way to review files is using the PowerShell ``Get-Content``
cmdlet on the remote server. This works great for glancing at small files or
simple searches.

In the following example we print out the hosts file:

{% highlight powershell %}
Invoke-Command -ComputerName 'BadServer' -ScriptBlock {
    $hostFile = 'C:\Windows\System32\drivers\etc\hosts'
    Get-Content $hostFile
}
{% endhighlight %}

You can get fancier using ``more`` and ``Select-String`` (aka the Powershell
Grep). Using these commands you can read larger files in chunks or search for
text in files/directories.

{% highlight powershell %}
# Start an interactive session to BadServer
# This must be run separately before running the other commands
Enter-PSSession 'BadServer'

# Print the contents of the host file in bitesized chunks
$hostFile = 'C:\Windows\System32\drivers\etc\hosts'
Get-Content $hostFile | more

# Find all occurences of POST in files underneath the C:\inetpub\logs directory
dir 'C:\inetpub\logs' -Recurse | Select-String 'POST' | more
{% endhighlight %}

<span id="core-sln-07"></span>

## 7. Configuring files on the server

Like the [previous example](#core-sln-06) you can use PowerShell to create a
file share on the remote server to allow you to edit files remotely. The only
difference from the previous example is the permissions applied to the file
share.

With these simple PowerShell commands you can create a file share to
``C:\inetpub`` with full access for Administrators on BadServer:

{% highlight powershell %}
Invoke-Commmand -ComputerName 'BadServer' -ScriptBlock {
    New-SmbShare -Name 'fullaccess' -Path 'C:\inetpub' -FullAccess 'Administrators'
}
{% endhighlight %}

Don't forget to remove the file share you created using the command:

{% highlight powershell %}
Invoke-Commmand -ComputerName 'BadServer' -ScriptBlock {
    Remove-SmbShare -Name 'fullaccess'
}
{% endhighlight %}

For more examples of managing/using review this [basics of SMB PowerShell][smb] blog post.

<span id="core-sln-08"></span>

## 8. Deploying new files

Deploying new files is very similiar to editting existing files. You can use
the steps from the [previous example](#core-sln-07) to create a file share for
copying new files to the server.

Alternatively, you could connect the remote server to a network file share then
copy files directly only the remote server. You can also use this to easily
move files off the remote server. By running the following commands one at time
would create, use and delete a connection to a network file share on the remote
server, BadServer:

{% highlight powershell %}
# Start a remote session to run the subsequent commands interactively
Enter-PsSession 'BadServer'

# Create a new drive (including specific credentials)
New-PSDrive -Name 'X' -Root '\\network\share' -PSProvider 'FileSystem'

# Do what you want to do with the remote share
cp 'X:\files' 'c:\files' -Recurse

# When you are all done you can remove the added drive
Remove-PSDrive -Name 'X'
{% endhighlight %}

If you need to use specific credentials on the network share use the
``Credential`` parameter like so:

{% highlight powershell %}
New-PSDrive -Name 'X' -Root '\\network\share' -PSProvider 'FileSystem' -Credential (Get-Credential)
{% endhighlight %}

<span id="core-sln-09"></span>

## 9. Recycle an Application Pool

Using the IIS Manager you can connect a local GUI to the remote server. This requires extra
setup on the target server shown in the [Bonus section](#core-bonus). Otherwise
follow these steps to connect to the remote computer:

1. On an extra computer open the IIS Manager
2. In the File menu, click on "Connect to a Server ..."
3. Enter the name of the server Select "Connect to Another Computer"
4. Enter the computer name
5. Enter your credentials
6. Name the connection
7. Profit

<figure class="image-center">
	<img src="/images/IIS.PNG" alt="Opening the connect to another computer dialog in the IIS Manager" />
	<figcaption>Connecting to another computer using the IIS Manager</figcaption>
</figure>

Once you have the IIS Manager connected you can recycle as needed.

The commandline options are very simple too.

The sledgehammer which will reset IIS completely is to run the following command:

{% highlight powershell %}
Invoke-Command -ComputerName BadServer -ScriptBlock {
	iisreset
}
{% endhighlight %}

If you want something more targetted you can use the PowerShell
``WebAdministration`` module. There are many fantastic commands in this module
for managing IIS which you can see by running:

{% highlight powershell %}
Get-Command -Module WebAdministration
{% endhighlight %}

These commands are run locally on the server being modified. I would recommend
using ``Enter-PsSession BadServer`` with your server. This will let you
interactively run the various commands.

This example shows reviewing and restarting application pools:

{% highlight powershell %}
# Import the module
Import-Module 'WebAdministration'

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

<span id="core-sln-10"></span>

## 10. Adjusting the Application Pools

To adjust an Application Pool you can again use the IIS Manager remotely.
Follow the exact same steps as [9. Recycle an Application Pool](#core-sln-09)
to connect.

You can also update the Application Pool settings from the commandline using the ``appcmd`` tool.
This tool can be used like ``WebAdministration`` to review/modify IIS settings.

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

Using ``appcmd`` takes getting used to. If you want to see what I mean read the
[appcmd introduction][intro] for an overview.

I had an AHA moment when I started understanding the configuration files used
by IIS. The primary files are ``applicationHost.config`` for
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

<span id="core-bonus"></span>

Bonus: Setting up IIS Remote Management
===============================================================================

Extra setup is required to use the IIS Manager on a remote server. There are
[technet][technet] and [iis][iis] articles describing how this is done.
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

Awesome.

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