---
layout: post
title:  "What is your rollback?"
date:   2014-09-22 23:11:07
categories: deployments rollback
---
Are you afraid of your deployments? Dread that moment when you hear your fellow
employee deploying new code and they utter the phrase "oh no". It doesn't have
to be this way.

Perhaps the best way to reduce the fear of deployments is to have a good
rollback plan. This is never a silver bullet but can take alot of the heat out
of deployments that go poorly. If you don't have a rollback plan people will do
very silly things to get the system up and running again. This means cutting
corners that may completely invalidate any testing you did for your
application.

<a href="https://www.flickr.com/photos/rudolf_schuba/153225000" style="display: inline" title="UNIX - Server Photo by Rudolf Schuba used under Creative Commons from Flickr">
	<img src="https://c1.staticflickr.com/1/44/153225000_698c62c38a_z.jpg?zz=1" width="640" height="480" alt="Programming at an old UNIX Server alone in an attic">
</a>

<p>
* <a href="https://www.flickr.com/photos/rudolf_schuba/153225000" style="display: inline" title="UNIX - Server used under Creative Commons from Flickr">Photo by Rudolf Schuba</a> used under <a href="https://creativecommons.org/licenses/by/2.0/">Creative Commons</a> (Who I am sure is not doing bad things)
</p>

With a recent system we were working on we decided to make this extremely
simple and reliable. We use the same process to deploy the application in
reverse. This means we will practice it all the time so that if we need to use
it in a moment of panic we are confident that it will work. Since we hate
manual work we have fully automated the process.

We decided to use [Blue/Green](http://martinfowler.com/bliki/BlueGreenDeployment.html)
deployments for our product. This meant that we could

```powershell
$newServers = New-Servers
Publish-Servers $newServers

```

We now have a

* Automated
* Practiced
* Simple
* Reliable
