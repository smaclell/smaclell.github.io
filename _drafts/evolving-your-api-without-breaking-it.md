---
layout: post
title:  "Evolving Your API Without Breaking It"
date:   2015-07-24 01:19:07
tags: versioning services api
---

There are a number of ways to version web APIs. When you decide to make
breaking changes to your API there is a very important order to follow. If you
don't you will make consumers of your API very sad. In this post I am going to
explain how we make update our APIs and slowly introduce changes which
otherwise would horribly break them.
