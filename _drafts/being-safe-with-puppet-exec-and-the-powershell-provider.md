---
layout: post
title:  "Being Safe With Puppet Exec and the PowerShell Provider"
date:   2015-02-05 22:29:00
tags: puppet powershell recommendations
---

We have learnt a few thing things since we started that have led us to be more
cautious when using PowerShell within Puppet. Over time we have learnt ways to
make Puppet safer and avoid common pitfalls.

We are still fairly new to Puppet and use ``exec`` regularly for specific tasks
with PowerShell. To ensure our manifests run only when needed we use one of
``unless``, ``onlyif``, ``creates`` or ``refreshonly``. Not including such a condition would
fill up our dashboard with nodes that think they are always changing and run
the ``exec`` commands too often.

Exceptions will cause ``onlyif`` to not run and ``unless`` will always run.
Syntax errors will cause ``onlyif`` to always run and ``unless`` to never run.
This is because you need to be very careful with your exit codes. Based on our
experience it is preferable to use ``unless`` instead of ``onlyif`` and
imperative to test your modules thoroughly.

TODO: Quote the puppet docs and indicate why that would be great.

Control All Exits
===============================================================================

The first time we tried to use ``unless`` and ``onlyif`` we tried returning
true/false from PowerShell only to find it did not work the way we hoped. Our
first manifest looked something like this:

{% highlight puppet %}
exec { 'enable_wsman':
  command  => 'Enable-PSRemoting -Force',
  unless   => '
    $service = Get-Service "WinRM"
    return $service.Status -eq "Running"
  ',
  provider => powershell,
}
{% endhighlight %}

We tried testing it and found that it never ran. This was because Puppet uses
the exit code of the ``onlyif`` and ``unless`` commands to determine if the
command needs to run. In this case PowerShell would always successfully run and
return 0 as the exit code. We need to exit from PowerShell with non-zero exit
codes so that PowerShell would understand what to do, shown fixed in the sample
below.

{% highlight puppet %}
exec { 'enable_wsman':
  command  => 'Enable-PSRemoting -Force',
  unless   => '
    $service = Get-Service "WinRM"
    if( $service -and $service.Status -eq "Running" ) {
      exit 0
    } else {
      exit 1
    }
  ',
  provider => powershell,
}
{% endhighlight %}

Spamming the Dashboard
===============================================================================

We really like the Puppet Dashboard to know how our servers are doing. It can
track what nodes are being updated and what changes have been applied. Or at
least it would be if ``exec`` resources only ran when they updates are needed.
If your resources are not configured to run once or when needed, they will run
every time Puppet executes. This will cause the Dashboard to look like changes
are being made even when they aren't and makes the Dashboard less useful.

Every Puppet code I check for and recommend:

> If you use ``exec`` in your manifests,
> make sure they only run if they need to make changes.

Puppet has many ways that you can ensure ``exec`` only runs when required and
picking one that makes sense for your usage is easy! These are the ``exec``
attributes control when and whether it will run:

- ``unless`` For every time you can test for exactly what is updated.
             This is the primary attribute we use to constrain when our
             ``exec``'s are applied.
- ``creates`` If the command results in a file or folder being created. This
              might be a sign one of the other resources like ``file`` or
              ``package`` would be a better fit.
- ``refreshonly`` Only run the ``exec`` when triggered by something else.
                  Use this option sparingly since it does not guarantee that
                  what the ``exec`` does is still correctly configured.
- ``onlyif`` Test your stuff and use ``unless`` instead. Read on to learn why.

OnlyIf No Exceptions
===============================================================================

Initially we used a mix of ``unless`` and ``onlyif`` depending on which option
was a more natural fit for detecting if the resource needed to run. Then we
noticed that some of our manifests were not running when we thought they would.
Take the following example that enables WinRM and configures the memory size:

{% highlight puppet %}
exec { 'enable_wsman':
  command  => 'Enable-PSRemoting -Force',
  onlyif   => '
    $service = Get-Service "WinM"
    if( $service -and $service.Status -eq "Running" ) {
      exit 1
    } else {
      exit 0
    }
  ',
  provider => powershell,
}

exec { 'set_wsman_shell_memory_limit':
  command  => 'Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value 1024',
  onlyif   => '
    $value = (Get-Item -Path WSMn:/localhost/Shell/MaxMemoryPerShellMB).Value
    if ( $value -gt 1024 ) {
      exit 2
    } elseif( $value -eq 1024 ) {
      exit 1
    } else {
      exit 0
    }
  ',
  provider => powershell,
  require  => Exec['enable_wsman'],
}
{% endhighlight %}

This code will enable PowerShell Remoting if the WinRM service is not running
and then adjust the maximum memory size to 1024MB as a minimum value. At least
it would if not for the defects I added to each resource. Unless you looked
really closely and tested it thoroughly you might not find it. Both cases would
cause exceptions at runtime which would result in Puppet exiting with a
non-zero exit code.

Since ``onlyif`` only runs if the command has an [exit code of 0][onlyif] these
resources will never run when there is an exception since PowerShell will
always have a non-zero exit code. For this reason we began switching our
manifests that used ``onlyif`` over to ``unless``. This would guarantee that
our manifests would run and that the machine be correctly configured.
Exceptions happen and any unexpected Puppet runs show up clearly in the
dashboard.

Unless There Are Syntax Errors
===============================================================================

In preparing this blog post I found out that how I was expecting ``onlyif`` and
PowerShell to behave was not the full story. Take a look at the first version
of the code sample above:

{% highlight puppet %}
exec { 'enable_wsman':
  command  => 'Enable-PSRemoting -Force',
  unless   => '
    $service = Get-Service "WinRM"
    if( $service -and $service.Status -eq "Running" ) {
      exit 0
    } else {
      exit 1
    }
  ',
  provider => powershell,
}

exec { 'set_wsman_shell_memory_limit':
  command  => 'Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value 1024',
  onlyif   => '
    $value = (Get-Item -Path WSMan:/localhost/Shell/MaxMemoryPerShellMB).Value
    if ( $value -gt 1024 ) {
      exit 2
    } else if( $value -eq 1024 ) {
      exit 1
    } else {
      exit 0
    }
  ',
  provider => powershell,
  require  => Exec['enable_wsman'],
}
{% endhighlight %}

The updated code sample still has issues but this time they are purely syntax
errors. I was expecting it to never run an exit with a non zero exit code but
instead ``Exec['set_wsman_shell_memory_limit']`` would run every time!

I would have thought this would be like any other exception and stop PowerShell
from executing. According to this early post about [PowerShell exit codes][psexit],
an uncaught exception will exit with 1 whereas with a normally running script
the exit code will be 0. In testing it appear that syntax errors are not like
other exceptions and cause an exit code of 0 instead of 1. If you want to see
an example of this check out the [connect][connect] issue I logged.

Being Re-Runnable
===============================================================================

Prior to using Puppet we had grown a series of scripts for automating various
tasks. Typically they needed to handle already being run and correcting slight
differences. The ability to rerun the scripts safely allowed users to trust the
scripts to ensure they did their intended task.

We have continued to use Puppet in much the same way and benefit from knowing
that when it is done running the machines are in a consistent state. Like our
previous scripts, writing re-runnable ``exec`` resources has helped make the
manifests more widely applicable and accommodate more differences. This has
been even more useful when  ``onlyif`` and ``unless`` conditions trigger when
the operation has already been performed.

Most commands are simple setters and the conditions compare the target setting
against the expected value, as shown by the ``Exec['set_wsman_shell_memory_limit']``
resource. Each ``exec`` should perform only one change to simplify both the
command and the condition.

Checking It Twice
===============================================================================

When using ``exec`` it is important to make sure the commands behave as
expected. At the very minimum, I always run my manifests twice, once to test
that it runs correctly and then a second time to verify that running again does
not change anything else and does not run again. Testing the manifests in this
blog post helped me to find issues that I otherwise would not have found.

This normally involves testing the module locally using specs and/or applying
the manifest. After I am done testing locally I run the manifest on a blank
machine twice. Testing locally provides feedback much faster and checks that
the basics of the manifest work. Repeating the process on a blank machine
makes sure that there is nothing special about my machine that caused the
test to pass.

When using PowerShell in a manifest, I will often try running the script
outside of Puppet to verify it behaves correctly in isolation. If I have used
any conditions I will then check them in the same manner. Separating the two
technologies helps limit what is being tested and eliminates the interaction
with Puppet. Testing both with and without Puppet is comparable to unit testing
just the PowerShell and then integration testing both technologies together.

Dealing with Arguments
===============================================================================

Bridging the language differences between PowerShell and Puppet has changed how
we write our puppet manifests. We initially used a mix of single and double
quotes for PowerShell strings and escaped everything. To clearly separate the
PowerShell from Puppet and avoid escaping we started using this pattern:


{% highlight puppet %}
# This value would come from hiera or elsewhere in the manifest
$max_memory_per_shell_mb = 1024

$args = "\$maxMemoryPerShellMB = ${max_memory_per_shell_mb}"

$command = '
  Set-Item `
    -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB `
    -Value $maxMemoryPerShellMB
'

$unless = '
  $value = (Get-Item -Path WSMan:/localhost/Shell/MaxMemoryPerShellMB).Value
  if ( $value -ge $maxMemoryPerShellMB ) {
    exit 0
  } else {
    exit 1
  }
'

exec { 'set_wsman_shell_memory_limit':
  command  => "${args};${command}",
  unless   => "${args};${unless}",
  provider => powershell,
}
{% endhighlight %}

Declaring all the arguments up front clearly shows the inputs and separates
them from the behaviour of the scripts. The scripts themselves do not need any
escaping thanks to the single quotes. What will be run by PowerShell and the
Puppet resources are separated, allowing each one to focus on their own
concerns without being entangled. This works great for small snippets but
the larger or more complicated the scripts becomes the less useful it is.

Follow The Script
===============================================================================

Ideally the PowerShell scripts being run by Puppet are small. The larger they
are the harder it is to keep them idempotent and continue to maintain them.
Like every other language keeping things small and readable is recommended.

There have been some scripts that became much more complicated, but were still
performing a single atomic operation. To deal with these larger scripts we
would pull them out into their own file, copy them to the target machine using
a ``file`` resource and then run them using ``exec``. Another fun twist on this
pattern is to declare the files as a template and include them inline.

Define(-itely) Puppetifying It
===============================================================================


Be Safe
===============================================================================

I hope that you found this advice useful. We are still learning how to be use
Puppet safely, especially when we use it mixed with PowerShell.

<hr />

[onlyif]:  https://docs.puppetlabs.com/references/latest/type.html#exec-attribute-onlyif
[unless]:  https://docs.puppetlabs.com/references/latest/type.html#exec-attribute-unless
[psexit]:  http://blogs.msdn.com/b/powershell/archive/2006/10/14/windows-powershell-exit-codes.aspx
[connect]: https://connect.microsoft.com/PowerShell/feedbackdetail/view/1121146/powershell-executable-syntax-error-exit-code-is-0
