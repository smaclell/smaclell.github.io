---
layout: post
title:  "What is your rollback plan?"
date:   2014-09-22 23:11:07
tags: deployments rollback
---
Are you afraid of your deployments? Dread that moment when you hear your fellow
employee deploying new code and they utter the phrase "oh no, this isn't good".
It doesn't have to be this way.

Perhaps the best way to reduce the fear of deployments is to have a good
rollback plan. This is never a silver bullet but can take the heat out of
deployments that go poorly. If you don't have a rollback plan people will do
very silly things to get the system up and running again. This means cutting
corners that may completely invalidate any testing you did for your
application or make any outage worst.

<a href="https://www.flickr.com/photos/rudolf_schuba/153225000" style="display: inline" title="UNIX - Server Photo by Rudolf Schuba used under Creative Commons from Flickr">
	<img src="https://c1.staticflickr.com/1/44/153225000_698c62c38a_z.jpg?zz=1" width="640" height="480" alt="Programming at an old UNIX Server alone in an attic">
</a>

<p>
* <a href="https://www.flickr.com/photos/rudolf_schuba/153225000" style="display: inline" title="UNIX - Server used under Creative Commons from Flickr">Photo by Rudolf Schuba</a> used under <a href="https://creativecommons.org/licenses/by/2.0/">Creative Commons</a> (Who I am sure is doing good things to his computers)
</p>

With a recent system we were working on we decided that a good rollback was a
priority for us and decided that there were four key properties we wanted:

* Automated
* Practiced
* Simple
* Reliable

To achieve these goals we decided on using the same process to deploy the
application in reverse so that we could rollback to older versions. Since we
deploy with every commit in our [Deployment Pipeline](http://martinfowler.com/bliki/DeploymentPipeline.html)
(or a detailed [Deployment Pipeline](http://www.informit.com/articles/article.aspx?p=1621865) overview)
we practice upgrading on every change. This means we also practice the process
we need for rollback all the time so when it is needed in that moment of
panic we are confident it will work. In order to deploy with every commit
there could not be any manual steps which meant we automated the entire
process. This automation has made the rollback process very simple and
since we use the same process on each build we are very confident it is
reliable.

The Application
-------------------------------------------------------------------------------

We decided to use [Blue/Green](http://martinfowler.com/bliki/BlueGreenDeployment.html)
deployments for our product. This is a very popular technique that can allow
for zero downtime and lower risk deployments. The gist is that you change one piece of
the application at a time by setting up the new version (green) beside the old
version (blue) then switching traffic to the new version.

To deploy new application code our process looks like:

1. Create a new server with the new code
1. Test the new server
1. Put the new server into the load and start serving traffic
1. Take an old server out of the load
1. Repeat until only new servers are left

**BOOM!!!!**, if something goes horribly wrong then:

1. Put the old server into the load and start serving traffic
1. Take the new server out of the load

The beauty of this is that switching between the new and old version is the
same operation. There is nothing special about it. If you want to get fancier
you can make changing the versions atomic to avoid serving traffic with both
versions at the same time. If you want to watch or test your changes for a
while to make sure they are safe you can switch a small percentage of traffic,
a technique called [Canary Releases](http://martinfowler.com/bliki/CanaryRelease.html).
For us the overlap between versions is very small and the systems are simple
enough to not need these enhancements.

The Database
-------------------------------------------------------------------------------

Rollback gets a whole lot harder for systems that need to maintain state or
have a database. For this we follow a similar pattern but have upgrade and
downgrade migration scripts for our database.

For several applications we have decided to make the database changes backwards
compatible with the previous application code and apply them prior to updating
the code. This means that for complicated changes we need to perform them over
several releases but this has seldom been a problem. We then ship the migration
scripts with the application so that we always know what versions are
compatible.

Our process typically looks like this:

1. Make sure the application is healthy
1. Upgrade the database
1. Make sure the application is healthy

**IT'S MELTING!**, if things go bad then we quickly rollback:

1. Downgrade the database
1. Make sure the application is healthy

Both upgrade and downgrade (rollback) scripts and processes look roughly the
same but typically use very different scripts because the database changes
required are completely different. To make this easier for .NET we have been
enjoying a library called [FluentMigrator](https://github.com/schambers/fluentmigrator/wiki)
which makes writing your upgrades and downgrades really easy. If .NET is not
your style there is always [Active Record Migrations](http://guides.rubyonrails.org/migrations.html)
for an extremely popular framework for migrations. The frameworks understand
what has/has not been applied to the database and the order that migrations
need to run. This makes it simple to go from nothing to a complete database in
minutes and rollback changes when needed.

We needed to plan so that all our migration scripts could run online. Most
migrations are minor and don't need alot of effort. Where it starts to get much
harder is data needs to be migrated between tables or shifting large parts of
the schema such as splitting/combining/killing tables. These are some successful
strategies we have used to perform safe online migrations:

1. Minor schema additions/changes that do not affect the old application
1. Use triggers/database tools to replicate necessary data
1. Leave the data/schema and migrate it with the next release
1. Have the application tolerate the difference or do the conversion
1. Write a more complicated migration that is safe online

For the last option a co-worker of mine, [Michael J. Swart](https://twitter.com/MJSwart),
had a fantastic series about doing migrations online using SQL Server called
[Modifying Tables Online](http://michaeljswart.com/2012/04/modifying-tables-online-part-1-migration-strategy/).
He walks through what initially looks like a simple change that turns into
rebuilding a table by replicating the data to a new table then switching with
the old table. If you really want to persevere through complicated online
migrations I would highly recommend reading Michael's post for some
inspiration.

The Result
-------------------------------------------------------------------------------

Having a strong rollback plan has changed the way we do releases. We have not
needed it very often but when we did it was a lifesaver. We are no longer live
in fear of bad deployments and are confident we can get back to a working state
quickly and easily.

With a little bit of planning and effort we now have a rollback plan that is:

* Automated
* Practiced
* Simple
* Reliable

What is your rollback plan?
