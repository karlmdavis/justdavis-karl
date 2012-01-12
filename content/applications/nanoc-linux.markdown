--- 
title: nanoc-linux
kind: topic
summary: Describes the setup of nanoc on a Linux machine.
---

# `nanoc` on Linux

[nanoc](http://http://nanoc.stoneship.org/) is a light-weight content management system that can be used to replace traditional blogs and wikis.  This page documents how to install, configure, and use it on a Linux machine.


## Installation

Run the following commands to install `nanoc` and its dependencies:

    # apt-get install apt-get install ruby ruby1.8-dev rubygems1.8
    # gem install nanoc kramdown adsf less rainpress

Add the Ruby gems binaries to the user path by adding the following to the ~/.profile file:

~~~
# Add Ruby's gems binaries to the path
if [ -d "/var/lib/gems/1.8/bin" ] ; then
    PATH="$PATH:/var/lib/gems/1.8/bin"
fi
~~~


