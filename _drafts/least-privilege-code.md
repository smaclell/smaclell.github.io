---
layout: post
title:  "The Least Privilege applied to Code "
date:   2015-11-20 00:27:07
description: "Extend the Principle of Least Privilege to your code"
tags: code ideas minimalist
---

There is a principle in computer science called the [Principle of Least Privilege][PoLP].
It is a recommended security practice of
giving any process, user or program the least access possible. I think this
idea should also be applied to your code. You should **restrict your code as
much as possible.**

The idea behind the standard Principle of Least Privilege is straight forward
and typically applied to security. The wider the surface area of any system the
more hackers can attack. By using the lowest permissions possible
for any user, process, server or service what could be lost or stolen when a
system is compromised is reduced.

Great. We can also apply the idea to code. Restrict what? The visibility
between classes/assemblies to intentionally define a smaller public API.
You can include the smallest amount of data possible in your service APIs.

You should be very intentional with what you make public. Anything you make
public will need to be supported and maintained. Once made public removing or
changing an API is harder. There is more to maintain and changes which would
otherwise be private could cause breaking changes.

For this reason, I favour minimalist APIs. Everything not public can be more easily
refactored and improved. By keeping as much code as you can private/internal, you
shrink public API's surface area.

In my next post, I will show you how you can leverage the C# keywords to better
control the API of your classes/assemblies.

[PoLP]: https://en.wikipedia.org/wiki/Principle_of_least_privilege
