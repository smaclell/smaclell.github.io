---
layout: post
title:  "What is your rollback plan?"
date:   2014-09-22 23:11:07
categories: deployments rollback
---
Are you afraid of your deployments? Dread that moment when you hear your fellow
employee deploying new code and they utter the phrase "oh no, this isn't good".
It doesn't have to be this way.

Perhaps the best way to reduce the fear of deployments is to have a good
rollback plan. This is never a silver bullet but can take the heat out of
deployments that go poorly. If you don't have a rollback plan people will do
very silly things to get the system up and running again. This means cutting
corners that may completely invalidate any testing you did for your
application.

<a href="https://www.flickr.com/photos/rudolf_schuba/153225000" style="display: inline" title="UNIX - Server Photo by Rudolf Schuba used under Creative Commons from Flickr">
	<img src="https://c1.staticflickr.com/1/44/153225000_698c62c38a_z.jpg?zz=1" width="640" height="480" alt="Programming at an old UNIX Server alone in an attic">
</a>

<p>
* <a href="https://www.flickr.com/photos/rudolf_schuba/153225000" style="display: inline" title="UNIX - Server used under Creative Commons from Flickr">Photo by Rudolf Schuba</a> used under <a href="https://creativecommons.org/licenses/by/2.0/">Creative Commons</a> (Who I am sure is doing good things to his computers)
</p>

The Application
-------------------------------------------------------------------------------

With a recent system we were working on we decided that this was a priority for
us and wanted it to be simple and reliable. We use the same process to deploy
the application in reverse. This means we will practice it all the time so that
if we need to use it in a moment of panic we are confident that it will work.
Since we hate manual work we have fully automated the process.

We decided to use [Blue/Green](http://martinfowler.com/bliki/BlueGreenDeployment.html)
deployments for our product. This is a very popular technique that can allow
for zero downtime changes to a system. The gist is that you change one piece of
the application at a time by setting up the new version (green) beside the old
version (blue) then switching traffic to the new version.

To deploy new application code our process looks like this:

1. Create a new server with the new code
1. Test the new server
1. Put the new server into the load and start serving traffic
1. Take the old server out of the load

**BOOM!!!!**, if something horrible goes wrong do this.

1. Put the old server into the load and start serving traffic
1. Take the new server out of the load

The beauty of this is that switching between the new and old version is the
same operation. There is nothing special about it. If you want to get fancier
you can make changing the load atomic to prevent serving traffic with both
versions at the same time. Or if you want to watch your changes for a while to
make sure they are safe you can switch a small percentage of traffic, a
technique called [Canary Releases](http://martinfowler.com/bliki/CanaryRelease.html).
For us this overlap was very small and the systems are not large enough to need
these enhancements.

The Database
-------------------------------------------------------------------------------

This gets a whole lot harder for systems that need to maintain state or access
a database. For this we follow roughly the same pattern but have a migration
scripts for upgrading and downgrading out database. For several applications we
have decided to make the database changes backwards compatible with the
previous application code. This means that for complicated changes we need to
perform them over several releases but this has seldom been a problem. We then
ship the migration scripts with the application so that we always know what
versions are compatible.

Our process typically looks like this:

1. Make sure the application is healthy
1. Upgrade the database
1. Make sure the application is healthy

**IT'S MELTING!**, if things go bad then we quickly rollback.

1. Downgrade the database
1. Make sure the application is healthy

Looks roughly the same but typically has very different scripts because for
databases the operations required to upgrade are completely different than the
operations required to downgrade. To make this easier for .NET we have been
enjoying a library called [FluentMigrator](https://github.com/schambers/fluentmigrator/wiki)
which makes writing your upgrades and downgrades really easy. If .NET is not
your style there is always [Active Record Migrations](http://guides.rubyonrails.org/migrations.html)
for an extremely popular framework for migrations. The frameworks understand
what has and has not been applied to the database and the order that migrations
need to run. This makes it really easy to go from nothing to a complete
database for your application in minutes.

We also need to plan for whether or not these migrations can occur online. This
has not always been easy but since most of migrations are minor schema changes
it has not been very bad. Where it starts to get harder is when you need to
change data contained within the system. We have typically employed one three
choices:

1. Use triggers/database tools to replicate necessary data
1. Leave the data and migrate it with the next release
1. Have the application tolerate the difference or do the conversion
1. Write a more complicated migration to keep it safe online

For the last option a co-worker of mine, Michael J. Swart, had a fantastic
series about doing complex migration online using SQL Server called
[Modifying Tables Online](http://michaeljswart.com/2012/04/modifying-tables-online-part-1-migration-strategy/).
If you really want to persevere and do your migrations online I would recommend
reading Michael's post.

The Result
-------------------------------------------------------------------------------

Having a strong rollback plan has changed the way we do releases. We have not
needed it very often but when we did it was a lifesaver. We are no longer live
in fear of bad deployments and are confident we can get back to working state
quickly and easily.

With a little bit of planning we now have a rollback plan that is:

* Automated
* Practiced
* Simple
* Reliable

What is your rollback plan?
