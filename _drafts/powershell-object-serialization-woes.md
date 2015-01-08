---
layout: post
title:  "PowerShell Object Serialization Woes"
date:   2014-09-22 23:11:07
tags: troubleshooting, powershell, logstash, elasticsearch
---

Recently, we found a fun<sup id="reverse-note-1"><a href="#note-1">1</a></sup>
intermittent defect that was very hard to pin down and reproduce. This is our
story about what happened, how we resolved it and what we learnt.

We have some PowerShell scripts that write messages to [LogStash][elk] that
started to have messages that would not show up in [ElasticSearch][elk]. What
messages that would go through seemed to change day to day. Many different
systems use the same LogStash and all our messages were written in a similar
way, JSON over TCP. We did notice that some of the messages that were getting
through looked completed different than the others.

A good message body would look like this:

{% highlight json %}
{
  "message": "Hello World",
  "context": {
    "event": "StartUp",
    "level": "Info",
    "data": "Example"
  }
}
{% endhighlight %}

A bad message body would look like this:

{% highlight json %}
{
  "message": "Hello World",
  "context": {
    "event": "StartUp",
    "level": "Info",
    "data": {
        "Members": [
          {
            "MemberType": 4,
            "Value": 7,
            "IsSettable": false,
            "IsGettable": true,
            "TypeNameOfValue": "System.Int32",
            "Name": "Length",
            "IsInstance": true
          },
          {
            "MemberType": 64,
            "OverloadDefinitions": [
              "bool Equals(System.Object obj)",
              "bool Equals(string value)",
              "bool Equals(string value, System.StringComparison comparisonType)"
            ],
            "TypeNameOfValue": "System.Management.Automation.PSMethod",
            "Name": "Equals",
            "IsInstance": true
          }
      ],
      "ImmediateBaseObject": "Example",
      "BaseObject": "Example",
      "TypeNames": [
        "System.String",
        "System.Object"
      ]
    }
  }
}
{% endhighlight %}

The Changes
===============================================================================

Before going deep into the issue itself I wanted to explain how the changes
that caused the problem were first introduced.

The changes that led to this issue happened weeks before finding the issue. We
were trying to refactor our logging to make it more consistent, simplify it and
incorporate it into a new project. The new project brought with it a large set
of new libraries and changes that remained relatively isolated.

In working on the new code I had seen a small issue with the log serialization and
introduced a small change (*cough* hack *cough*) to workaround the issue. The
data was causing a circular reference while serializing which I adjusted to
ignore since I knew that our input data did not have any circular references.
The serialization output looked about the same as the bad message above but
wrote it off at the time. With my small change in place the system seemed to
work and so I moved onto the next thing.

Okay, now back to digging into the issue.

The Troubleshooting
===============================================================================

Digging into the issue was hard because it only happened intermittently. We
started trying to isolate the issue to which log messages caused the error but
could not find any discernible patterns. The messages that were logged or not logged changed
daily. At first we did not know why the messages were not showing up and we did
not know about the messages in the bad format. What was really weird is that we
would step line by line through the code and output potential messages and
everything would look fine.

The first breakthrough came after we talked to
[Jeffery Charles][jeff], a LogStash/ElasticSearch user from another team in the
company. They were having the same issue from on a different system. He saw
error logs on their LogStash server indicating that messages with different
formats were being ignored by ElasticSearch. LogStash/ElasticSearch work by
receiving messages using LogStash and then ElasticSearch indexes them. If there
are two messages sent with a conflicting schema then the only messages matching
the first schema are written to the index. Messages where a property's type
changes, i.e. from a ``string`` to and ``object``, cause this conflict to
occur. A new index is created daily which explained is why the messages that
were being saved changed daily and why only some messages made it through.

This behaviour meant that a single bad message from the new system could break
the log messages for other systems using our LogStash server. This expanded the
surface area that we thought was affected by the defect dramatically. Messages
not getting indexed meat that there was data-loss and that none of the affected
code could be released into production. Originally, we thought only message
from the new system were missing but this defect meant that the new system
could write bad messages that could break existing systems. We needed to find a
fix fast.

We then focused all our effort on LogStash and the logging module. Daryl, an
amazing developer on our team, suggested that we try looking closer at the
messages sent from the new library by faking being the LogServer receiving
messages. This helped us find the bad message format and what logs were
affected. We were very confident that this problem was introduced somewhere
with our new changes. Using this technique we were able to confirm that only
the new project was affected.

We then honed
in on some obvious differences between the new code and how the old code sent
their messages to LogStash. Both sent the message content as JSON blobs over
TCP but used a slightly different intermediate data structure to pass data
around in PowerShell. The original used primarily <code>HashTable</code>'s
whereas the new format converted to <code>PSObject</code>'s as an intermediate.
This seemed like a good area to focus on because the fields in the message were
similar to those found on a <code>PSObject</code>. We tried a few different
fixes eliminating or moving the ways <code>PSObject</code> was used to make the
new code closer to the old code but nothing worked. Due to different messages
being filtered daily, testing each change required waiting until the next day
to confirm whether the fixed worked.

After a few failed fixes, Daryl became frustrated and for good reason.
At no point did we understand the underlying problem and had only been trying
to address potential differences around what we thought the issue was. We had thought that
there was something specific to the new logging we had introduced that caused
the issue and so had tried eliminating any differences from the old code.

Daryl wanted to go deeper and truly understand the problem. He then tried to
reproduce the issue by isolating the code writing messages to LogStash and an
mix of messages with different contents, formatting and creation techniques.
Within a day he found exactly what caused the issue and then refined a simple
way to reproduce it.

The problem was not introduced directly by the new code but serializing from
different objects to JSON in PowerShell. Depending on how the message was
created it may be wrapped in an additional PowerShell object that would
cause something completely different to be serialized.

Consider the following example:

{% highlight powershell %}
# In this example to avoid dependencies I am using the built in serializer but
# you could happily substitute in your favourite like Json.NET
Add-Type -AssemblyName System.Web.Extensions

# Our function to do the serialization looked something like this
function Convert-ToJsonString( $data ) {
    $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $output = $serializer.Serialize( $data )
    return $output
}

# This will output the same string with the right formatting
function Test-Good {
    "pass"
}

$pass = Test-Good
Convert-ToJsonString @{ test = $pass }

# This will be a bad message and will throw due to a circular reference
# Ignoring circular references would then result in the bad format
function Test-Bad {
    return "fail"
}

$fail = Test-Bad
Convert-ToJsonString @{ test = $fail }
{% endhighlight %}

We tried a few more cases and found that the issue only occurred in
PowerShell 2.0 and not on 3.0 or 4.0.

From what we could tell the normal .NET objects were being wrapped by what
looked like a <code>PSObject</code>. In our earlier debugging it was impossible to see when
it was happening from a normal PowerShell prompt since as soon as the object
was printed it would only show the base object. Detecting when the case
happened in code also proved to be troublesome because you could not see the
wrapping type or output when it was present. The only way to reliably reproduce
this the bad content was to call .NET class to serialize it.

The Solution
===============================================================================

At this point we knew exactly where the issue was and came up with three fixes
that would solve it.

1. **Change all the code to not return values using this pattern.**
   At this point there was enough code spread out far enough that it would have
   taken a large amount of time to update everything. The easiest thing to do
   here would have been to pull the release and then redo the development. It
   would have been costly but better than affecting production with the defect.

2. **Upgrade to PowerShell 3+.**
   We have wanted to do this for a VERY long time and often talk about it. Even
   though it is an important (but not urgent) technical change we have decided
   against taking the plunge. We realized that in this instance while there is
   significantly more urgency to performed the update if this was the solution,
   for that reason it makes this the worst time to update the PowerShell
   version. The added pressure of fixing this defect and one way nature of
   updating PowerShell would greatly increase the likelihood of more issues.

3. **Serialize ourselves to "unwrap" the objects.**
   Once we narrowed down the interaction between the returned objects and the
   serialization we found that it was possible to get just the desired value
   back. You could do so by casting to the correct type and normally determine
   the type using the <code>-is</code> operator. I say normally because again
   some of the potential values that actually were wrapped appeared their
   intended type but were actually still wrapped when passed to the serializer.

We chose option 3. because it was relatively isolated, could be easily tested
with the case we reproduced and would be easy to implement. After weeks of
tracking down this defect a developer was able to implement this fix in a
day. Once it was everywhere and we confirmed that there were no more missing
log messages there were high-fives all around.

We did strongly consider moving to PowerShell 4.0 to fix the issue but the risk
was too great. Our solution can be easily replaced when we finally do and even
be made future compatible before we make the switch so that things go smoothly.

Lessons Learnt
===============================================================================

Phew. You made it this far! Congratulations. The ups and downs of investigating
this defect were tough but finding the root cause and fix the problem was worth
it. Throughout it all we did learn a few things.

Know why something works or especially why it does not work.
-------------------------------------------------------------------------------

Throughout most of the investigation we did not know what was causing the
problem. We knew exactly what changes had been made to the system but even then
did not have much to go on in determining the root cause.

Daryl kept pressing the team to dig deeper into the code and find the root
cause. He stressed understanding **why** the system was behaving the way it was
and only fixing that exact problem. Guided by the desire to understand, he
systematically found the reason behind the issue and a concise way to reproduce
the it. Part of why the issue took longer fix was because we tried several
fixes based on hunches to address what we thought was the most likely cause.

TODO: How did Daryl do it?
I think we call can troubleshoot like Daryl if we want to. Patiently isolating
potential areas until the only code left contains the problem.

Small "band-aid" changes cause problems.
-------------------------------------------------------------------------------

I could have fixed this entire problem when I found the circular reference
issue with the serialization. I was being sloppy, lazy and any other word you
like to describe a bad programmer with.

Instead of hastily slapping code in place and moving on, I needed to take the
time to investigate further. Since I was not expecting any circular references
and making a change to allow them is a dead give away something else is wrong.
I had briefly spent time working on it and looking into it but needed to the
professional thing and ask for help.

At the time I felt like I needed to make some artificial deadline and pushed
through the hacky fix. The final fix took a day. Debugging it and finding it
the second time took weeks on and off for multiple people. Taking a shortcut
like this just is not worth it and cost much more than it saved.

Rather than beating myself up about this dumb decision; I decided that I wanted
to share this story with you so that we both can avoid the same mistake that I
made.

<hr />

*I would like to thank Josh Groen and Daryl McMillan for their patience while
looking into this issue.*

<hr />

<span id="note-1"></span>
<a href="#reverse-note-1">1.</a> I have weird definition for fun ... not
everyone feels the same.

[elk]:  http://www.elasticsearch.org/overview/
[jeff]: http://www.beyondtechnicallycorrect.com/
