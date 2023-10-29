---
title: nanoc on Linux
layout: it_doc
description: Describes the setup of nanoc on a Linux machine.
---

[nanoc](http://http://nanoc.stoneship.org/) is a light-weight content management system that can be used to replace traditional blogs and wikis.  This page documents how to install, configure, and use it on a Linux machine.


## Installation


### Ubuntu 12.04 and Earlier

Run the following commands to install `nanoc` and its dependencies:

```shell-session
$ sudo apt-get install ruby ruby1.8-dev rubygems1.8
$ sudo gem install nanoc kramdown adsf less rainpress coderay nokogiri therubyracer
```

Add the Ruby gems binaries to the user path by adding the following to the ~/.profile file:

```shell
# Add Ruby's gems binaries to the path
if [ -d "/var/lib/gems/1.8/bin" ] ; then
    PATH="$PATH:/var/lib/gems/1.8/bin"
fi
```


### Ubuntu 12.10 and Later

Run the following commands to install `nanoc` and its dependencies:

```shell-session
$ sudo apt-get install ruby ruby1.9.1-dev
$ sudo apt-get install build-essential libxml2-dev libxslt-dev
$ gem install nanoc kramdown adsf less rainpress coderay nokogiri therubyracer builder mime-types systemu
```
