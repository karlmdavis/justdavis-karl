---
title: Feist Development Environment
parent: /it/feist
layout: it_doc
description: Describes the steps necessary to setup a software development on feist.
---

This {% collection_doc_link /it/feist baseurl:true %} sub-guide describes the steps necessary to setup a software development on the computer.

In addition to the development environment setup described below, the following guides were also followed:

* {% collection_doc_link /it/tmux baseurl:true %}
* {% collection_doc_link /it/nanoc-linux baseurl:true %}


## Miscellaneous: SSH

The SSH key pair for the user `karl` was copied from its primary "home" in AFS, as follows:

```shell-session
$ cp /afs/justdavis.com/user/karl/id/id-karlmdavis-rsa ~/.ssh/id_rsa
$ cp /afs/justdavis.com/user/karl/id/id-karlmdavis-rsa.pub ~/.ssh/id_rsa.pub
```


## Miscellaneous: Git

[Git](http://git-scm.com/) is an open source distributed version control system, created by Linus Torvalds to aid in the development of Linux. It can be installed as follows:

```shell-session
$ sudo apt-get install git git-svn git-gui gitk
```


## C++ Development


### Build Essentials (GCC, etc.)

Ubuntu has a metapackage named `build-essential` that includes GCC, and all of the basic libraries required for Linux C/C++ development. It can be installed as follows:

```shell-session
$ sudo apt-get install build-essential
```


### Eclipse CDT

[Eclipse CDT](http://www.eclipse.org/cdt/) is a set of plugins for Eclipse that support the development of C and C++ using the IDE. Once Eclipse itself is installed (as described below), the CDT plugins can be installed, as follows:

1. Select **Help > Install New Software...**.
1. Select *Juno - http://download.eclipse.org/releases/juno* as the repository to "**Work with**".
1. Select the following items to install:
    * **Mylyn Context Connection: C/C++ Development**
    * **GCov Integration**
    * **GProf Integration**
    * **Valgrind Tools Integration**
    * **C/C++ GCC Cross Compiler Support**
    * **C/C++ Memory View Enhacements**
    * **C/C++ Remote Launch**
    * **Remote System Explorer End-User Runtime**
    * **Remote System Explorer User Actions**
    * **Autotools support for CDT**
    * **C/C++ Development Tools**
    * **C/C++ Library API Documentation Hover Help**
    * **C/C++ Unit Testing Support**
1. Click **Next**, **Next**, **I accept the terms of the license agreement**, and then **Finish**.
1. When prompted, select **Yes** to restart Eclipse.


#### Notes on Using Eclipse for C/C++ Development

* CMake's integration with Eclipse is workable, but unfortunately requires deleting and re-importing the project every time the CMake configuration is changed.
* Eclipse's code completion support is nice, but seems to fall down on large includes. This became a show stopper for me trying to work with `GL/glext.h`, which is over 10K lines. Eclipse just refused to parse this file, resulting in lots of spurious "Function glFoo could not be resolved" compilation errors.


### Netbeans

[NetBeans](http://netbeans.org/]) is another full featured Java-based IDE with comprehensive support for C/C++. The latest version can be downloaded from <http://netbeans.org/downloads/>, and should be installed as follows:

```shell-session
$ sudo mkdir /usr/local/bin/netbeans
$ sudo chmod a+w /usr/local/bin/netbeans
$ chmod a+x netbeans-7.2.1-ml-cpp-linux.sh
$ ./netbeans-7.2.1-ml-cpp-linux.sh
```

Proceed through the installer GUI, selecting the following options when prompted:

* **Install the NetBeans IDE to:** `/usr/local/bin/netbeans/netbeans-7.2.1`
* **Java environment for the NetBeans IDE**: (the default should be fine)

Once the installer has completed, NetBeans can be launched from the Ubuntu Dash.


### CMake

[CMake](http://www.cmake.org/) is a meta-build system for C/C++ that can generate Make files, Eclipse project files, and a number of other build system files. It can be installed as follows:

```shell-session
$ sudo apt-get install cmake
```


## Java Development


### OpenJDK

[OpenJDK](http://openjdk.java.net/) is an open source implementation of the Java Development Kit. It can be installed, as follows:

```shell-session
$ sudo apt-get install openjdk-6-jdk openjdk-6-source openjdk-7-jdk openjdk-7-source visualvm icedtea-7-plugin
```


### Apache Maven

[Apache Maven](http://maven.apache.org/) is a build system, most often used for Java projects. The latest release can be downloaded from <http://maven.apache.org/download.html>, and then installed as follows:

```shell-session
$ tar xzf apache-maven-3.0.4-bin.tar.gz
$ sudo mkdir /usr/local/bin/apache-maven
$ sudo mv apache-maven-3.0.4 /usr/local/bin/apache-maven/
```

Create the following file as `/etc/profile.d/apache-maven.sh`:

```
export M2_HOME=/usr/local/bin/apache-maven/apache-maven-3.0.4
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xmx512m"

if [ -d "$M2" ] ; then
        export PATH="$PATH:$M2"
fi
```

After logging out of Ubuntu and logging back in, the `mvn` command (and friends) will be available for use in terminals.


### Eclipse

[Eclipse](http://eclipse.org/) is an open source IDE, most often used for Java projects. The latest 64bit "Eclipse IDE for Java Developers" can be downloaded from <http://www.eclipse.org/downloads/>, and then installed as follows:

```shell-session
$ tar xzf eclipse-java-juno-SR1-linux-gtk-x86_64.tar.gz
$ sudo mkdir /usr/local/bin/eclipse
$ sudo mv eclipse /usr/local/bin/eclipse/eclipse-java-juno-SR1-linux-gtk-x86_64
```

An icon for Eclipse can be created manually using the "Main Menu" application for Ubuntu. If it's not already installed, install it as follows:

```shell-session
$ sudo apt-get install alacarte
```

In the "Main Menu" application, create a new shortcut in the "Programming" category with the following properties:

* **Type:** *Application*
* **Name:** `Eclipse Juno x86_64`
* **Command:** `/usr/local/bin/eclipse/eclipse-java-juno-SR1-linux-gtk-x86_64/eclipse`
* **Icon:** `/usr/local/bin/eclipse/eclipse-java-juno-SR1-linux-gtk-x86_64/icon.xpm`

After logging out of Ubuntu and logging back in, an icon for Eclipse will then be available in the Ubuntu Dash.
