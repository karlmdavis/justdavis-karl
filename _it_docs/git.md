---
title: Git Client
layout: it_doc
description: Describes the setup of a Git client.
---

[Git](http://git-scm.com/) is an open source version control system, originally developed by the creator of Linux, Linus Torvalds. It has a number of benefits over other version control systems: easy branching, good merge capabilities, and a distributed workflow. This page documents how to install, configure, and use it.


## Installation


### Ubuntu 12.10 and Later

Run the following command to install `git` and its dependencies:

    $ sudo apt-get install git

Once installed, configure the name and email address that Git will associate with commits made by the current user:

    $ git config --global user.name "Your Name"
    $ git config --global user.email you@example.com

