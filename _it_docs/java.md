---
title: Install Java JDKs
layout: it_doc
description: Describes how to install the Java JDKs.
---

This guide describes how to install the available [Java JDKs](http://en.wikipedia.org/wiki/Java_Development_Kit) on Ubuntu.

There are two primary variants of Java JDK available for use in Ubuntu: those provided by the [OpenJDK](http://openjdk.java.net/) project, and those provided by [Oracle](http://www.oracle.com/technetwork/java/javase/downloads/index.html).


## Installing OpenJDK

Installing OpenJDK is simple, just run the following command:

    $ sudo apt-get install openjdk-6-jdk openjdk-6-source openjdk-7-jdk openjdk-7-source

That will install both the Java 6 and Java 7 variants of the OpenJDK. The Java 6 one is installed, as it's needed for development on some older projects.


## Installing Oracle JDKs

References:

* [Ubuntu Wiki: Java](https://help.ubuntu.com/community/Java)
* [Install Oracle Java 7 in Ubuntu via PPA Repository](http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html)

Frustratingly, installing the proprietary Oracle JDKs on Ubuntu has gotten much more complicated than it used to be. Previously, they'd just been available in the default Ubuntu repositories. Now, however, Oracle only makes them available directly from their site.

Some enterprising folks have attempted to ease the pain of this with the creation of a "Java *installer*" package, which automatically downloads the installers from Oracle's site and installs them.

This installer package lives in a PPA, which can be added as follows:

    $ sudo add-apt-repository ppa:webupd8team/java
    $ sudo apt-get update

Once the PPA has been added, the Oracle JDKs can be installed as follows:

    $ sudo apt-get install oracle-java6-installer oracle-jdk7-installer

