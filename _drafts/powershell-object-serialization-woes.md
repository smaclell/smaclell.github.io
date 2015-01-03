---
layout: post
title:  "PowerShell Object Serialization Woes"
date:   2014-09-22 23:11:07
tags: troubleshooting, powershell, logstash
---

Recently we found a fun<sup id="reverse-note-1"><a href="#note-1">1</a></sup>
intermittent defect that was very hard to pin down and reproduce. This is our
story about what happened and how resolved it.

We have some PowerShell scripts that write messages to [LogStash][logstash]
that started to have messages that would not show up. What messages that would
go through seemed to change day to day. Many different systems use the same
LogStash and most of our messages were written in a similar way. We did notice
that some of the messages that were getting through looked completed different
than the others.

A good message would look like this:

{% highlight json %}
{
  "message": "Hello World",
  "context": {
    "event": "StartUp",
    "level": "Info"
  }
}
{% endhighlight %}

A bad message would look like this:

{% highlight json %}
{
  "message": "Hello World",
  "context": {
    "event": "StartUp",
    "level": "Info"
  }
}
{% endhighlight %}

The Changes
===============================================================================

The changes that led to this issue happened weeks before finding the issue. We
were trying to refactor our logging to make it more consistent, simplify it and
incorporate it into a new project.

In working on the code I had seen a small issue with the serialization early on
that I introduced a small change (*cough* hack *cough*) to work around. The
serialization output looked about the same as the bad message above but wrote
it off at the time.

Okay, now back to digging into the issue.

The Troubleshooting
===============================================================================

Digging into the issue was hard because it only happened intermittently. We
started trying to isolate the issue to which log messages caused the error but
could not find any discernible patterns. The messages that were logged changed
daily. At first we did not know why the messages were not showing up and we did
not find any of the messages in the bad format.

We thought the problem might be with LogStash but could not find anything in
the system or error logs.  The first breakthrough came after we talked to some
other LogStash [TODO link to Jeff's blog] users from another team in the
company. He had found an issue where using messages with different formats
would result in LogStash ignoring the messages. When LogStash has messages with
multiple conflicting schemas only the messages with the first schema are shown.
This was why we only were seeing some messages make it through. We also create
a new index for the data daily which explained why which messages which meant
the first schema for the first message each day decided which messages were
shown.

We then focused all our effort on LogStash. Daryl, an amazing developer on our
team, suggested that we try looking closer at the messages from the new library
by tapping into the logs directly. After we had tried recording the messages
directly from the sender we started seeing the bad format. We also checked the
existing systems writing to LogStash and found that they did not have this new
format which helped narrow it down to our new changes.

We had suspected the new changes all along because they were where most of the
changes were happening throughout everything logging to LogStash. We then honed
in on some obvious differences between the new code and how the old code sent
their messages to LogStash. Both sent the content as JSON blobs over TCP but
used a slightly different to pass data around in PowerShell. The original used
primarily HashTable's whereas the new format converted to PSObject's as an
intermediate. We tried a few different fixes eliminating or moving the ways
PSObject was used to make the new code closer to the old code but nothing
worked. Testing this was made harder since we needed to wait an entire day to
confirm whether the fixed worked.

After a few attempts at fixing it Daryl became frustrated and for good reason.
At no point did we understand the underlying problem and had only been trying
to address symptoms around what we thought the issue was. We had thought that
there was something specific to the new logging we had introduced that caused
the issue that was different than the old code and so had only worked to reduce
the differences.

Daryl wanted to go deeper and truly understand the problem. He then tried to
reproduce the issue by replicating just the code writing out the log message to
LogStash and a series of messages that could be provided. Within a day he found
exactly what caused the issue and then made an even simpler way to reproduce it
so that we could prevent it from ever happening again. The problem was
introduced not directly by the new code but by the serialization from objects
in PowerShell to JSON. It appeared that depending on how the object was created
that was being serialized it would result in a completely different object that
would be serialized.

TODO: Talk about the earlier debugging where stepping through did not show it

Consider the following example:

{% highlight powershell %}
# Our function to do the serialization looked something like this
function Convert-ToJsonString( $data ) {
	$output = TODO: Finish this code!
	return $output
}

# This will output the same string with the right formatting
function Test-Good {
	"pass"
}

$pass = Test-Good
Convert-ToJsonString $pass

# This will look like the bad message and it's crazy format
function Test-Bad {
	return "fail"
}

$fail = Test-Fail
Convert-ToJsonString $fail
{% endhighlight %}

We tried a few more cases and found that the issue only occurred in
PowerShell 2.0 and not on 3.0 or 4.0.

<hr />

*I would like to thank Josh Groen and Daryl McMillan for their patience and
help as we looked into this issue.*

<hr />

<span id="note-1"></span>
<a href="#revese-note-1">1.</a> I have weird definition for fun ... not everyone agreed.

[logstash]: todo