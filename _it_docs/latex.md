---
title: LaTeX
layout: it_doc
description: "Describes how to install and work with the LaTeX typesetting system."
---

This guide describes how to install and work with the LaTeX typesetting system.


## Ubuntu 12.04

References:

* [Launchpad Bug #712521, comment 57](https://bugs.launchpad.net/ubuntu/+source/texlive-base/+bug/712521/comments/57)
* [LaTeX Basics](http://en.wikibooks.org/wiki/LaTeX/Basics#Generating_the_document)
* [man latexmk](http://dev.man-online.org/man1/latexmk/)

On Ubuntu 12.04, there is a PPA available with a recent version of the most popular LaTeX distribution, TeX Live: [eX Live Backports PPA](https://launchpad.net/~texlive-backports/+archive/ppa). This PPA is needed as the version of TeX Live in the standard Ubuntu 12.04 repositories is over two years old (the 2009 release versus the 2012 one). [Bug #712521](https://bugs.launchpad.net/ubuntu/+source/texlive-base/+bug/712521) details the efforts being made to improve this situation in the standard repositories. In the mean time, the PPA can be installed as follows:

    $ sudo add-apt-repository ppa:texlive-backports
    $ sudo apt-get update

Once the PPA is installed, the LaTeX packages should be installed (FYI: this will take quite a while, as the install is about 3GB in size):

    $ sudo apt-get install texlive-full

The following command will build PDFs for any `.tex` files in the current directory:

    $ latexmk -gg -pdfps

