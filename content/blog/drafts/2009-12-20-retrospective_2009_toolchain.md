--- 
title: "Retrospective: 2009 Toolchain"
kind: article
created_at: 2009/12/20
tags: []
excerpt: "TODO"
publish: false
---

## Language Choice

For most companies developing business applications, language choice these days comes down to two options: .NET or Java.  When I started at Ridgetop, I was informed that the use of Java was mandated for the project I'd be working on.  While I'd used Java in school, all my contract work after that was done in .NET.  Switching back to Java after that was unpleasant.  Java's "out of the box" experience leaves a lot to be desired: its standard library is less comprehensive, less consistent, and not as well designed as .NET's.  In addition, C# is really a more expressive language than Java.  In all fairness to Java, most of this is due to age: C# was able to learn from Java's mistakes and successes, while Java's commitment to backwards compatibility has forced it to shoehorn in lessons learned from the newer languages-- if it was able to incorporate them at all.

Ridgetop ended up sticking with Java for most of its software development.  Looking back, it was probably the correct choice.  While .NET wins "out of the box," Java's healthy ecosystem of open source libraries eventually make up for that.  Once I had some professional experience with Java, I was able to put together a set of tools and libraries that made Ridgetop's software engineering team incredibly productive.  I can't really speak to the health of the .NET ecosystem anymore, but I'd hazard a guess that most of the third-party .NET libraries are still proprietary/commercial.

Even aside from the expense of a reasonable .NET toolchain, the lack of access to source for most things puts it at a serious disadvantage to Java.  I've come to rely on having access to the source of almost everything I work with.  It's incredibly handy for debugging purposes, and has also helped to make me a much better developer.  A huge part of any developer's growth is exposure to other developers' code.  With .NET, you're more or less limited to only your company's source.  With Java, Ridgetop's developers were able to learn from the author of every library they worked with.  As technical lead, I was able to ensure they learned from the best.

In the end, I think Java comes out ahead of .NET, but only if there are some senior developers around with the expertise necessary to put together the right toolchain.  Frankly, Java was probably the wrong choice for Ridgetop initially.  It took at least a year before the toolchain I put together was really up to par.  That's far too long.  Of course, that was a one-time cost for me: I can--and do--apply that toolchain to every new project I start on.  As always: make sure your development team is working with the best tools for *them*.

## Build System

If you're working in Java, there are several options out there for what build system to use.  The most popular choices are whatever-happens-to-be-provided-by-the-IDE, Ant, and Maven.  At Ridgetop, I settled on Maven somewhere after my first year.  Near as I can tell, it's the most sensible choice for any team working on more than one project at a time.  Believe me, I'm no fan of the ridiculously verbose POM configuration it requires for all but the most simple projects (though I hear Maven 3 will finally allow for something other than XML, TODO).  Nonetheless, it's combination of standardized project layout, sane versioning, dependency handling, and rich plugin ecosystem make it a solid choice.

At Ridgetop, Maven allowed us to split up three separate applications into a number of separate modules for each of the projects they supported.  At the time I left, Maven was easily managing over fifty separate projects, with a complex set of intra-project dependencies.  In addition, Maven's POM inheritance made my work as technical lead much easier: most of the configuration for each of those projects was handled in parent POMs that developers normally didn't have to see or think about.

At my new job, I'm in the process [TODO] of moving the Java projects I'm involved in to Maven, and the benefits of the move are already clear.  It's clear that--left on their own--developers do a lousy job of dependency management and versioning.  Going from "lib" folders full of unknown JARs to POM-specified dependencies will provide a much-needed level of rigor to the projects.  In addition, Maven's standard build conventions make things like testing, releases, and continuous integration much simpler.

[TODO: cut that last paragraph?]
