---
layout: post
title:  "Being Safe With Puppet Exec and the PowerShell Provider"
date:   2015-02-05 22:29:00
tags: puppet recommendations
---

Using PowerShell with ``exec`` in Puppet manifests is tricky. Exceptions will
cause ``onlyif`` to not run and ``unless`` will always run. Syntax errors will
cause ``onlyif`` to always run and ``unless`` to never run. You will need to
explicitly configure exit codes.

If you use ``exec`` in your Puppet manifests, you should use ``unless`` instead
of ``onlyif``. When the ``onlyif`` condition fails for some unknown reason it
can result in the ``exec`` not running at all.

We are sill fairly new to Puppet and use ``exec`` to do more specific tasks
with PowerShell. To ensure our manifests run only when needed we use one of
``unless``, ``onlyif`` or ``creates``. Not including such a condition would
fill up our dashboard with nodes that think they are always changing and run
``exec`` when not necessary.

OnlyIf No Exceptions
===============================================================================

At first we used a mix of ``unless`` and ``onlyif`` depending on which option
was a more natural fit for detecting if the resource needed to run. Then we
noticed that some of our manifests were not behaving the way we expected. Take
the following example that enables WinRM and configures the memory size:

{% highlight puppet %}
exec { 'enable_wsman':
  command  => 'Enable-PSRemoting -Force',
  onlyif   => '
    $ErrorActionPreference = "Stop"
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
    $ErrorActionPreference = "Stop"
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

The code will enable PowerShell Remoting if the WinRM service is not running
and then adjust the maximum memory size to 1024MB as a minimum value. I
intentionally added some small defects to each resource. Unless you looked
really closely and tested it thoroughly you might not find it. This can be even
worst if there is dynamic input that causes the ``onlyif`` to break.

Unless There Are Syntax Errors
===============================================================================

In testing this blog post I found out something more fun.

<hr />

While writing this post I found more behaviour that did not make sense to me and decided to revise the post.
TODO: This is not behaving the way you expected it to. Try again tomorrow.