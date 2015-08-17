---
layout: post
title:  "Moq Minute - Loosen your mocks"
date:   2015-04-16 00:27:57 -4:00
tags: moq moq-minute testing
---

I love Moq. I think it is the best .NET mocking library. Mocking can be fragile
when mocks are too restrictive. Using more permissive mocks can make your tests
smaller and avoid breaking.

Leave out setups/assertions not critical to the test

Use MockBehaviour.Strict less

Before Strict Heavily Constrained Mock
After default setup/returns without caring out values