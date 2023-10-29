# Development Environment Setup: `justdavis.com/karl`

This document details the setup for the tools used to develop the `justdavis.com` site. This site is primarily managed via [Jekyll](http://jekyllrb.com/), a static site generator.


## Install RVM and Ruby 3

References:

* [Installing RVM](https://rvm.io/rvm/install)

Ubuntu tends to ship with old versions of Ruby, and Jekyll tends to require newer versions of it. One common way to manage this mismatch is with RVM.

I haven't had to install RVM in a while; I've been carrying an old version of it around, but see the link above for instructions.

Let's assume that RVM is installed and its shell functions are available for new shells. To load those functions into already-open terminal sessions, you can run the folloing command in each:

    $ source /home/karl/.rvm/scripts/rvm

The following command can be used to install and activate a modern version of Ruby that will work with Kekyll:

    $ rvm install ruby-3.2.2
    $ rvm use 3.2.2


### RVM: Gemset for Jekyll

It's expected that different combinations of Ruby gems will be needed for different tasks. Accordingly, RVM supports the concept of "gemsets": named bundles of installed gems. Create a "`jekyll`" gemset and activate it, as follows:

    $ rvm gemset create jekyll
    $ rvm 3.2.2@jekyll

Install the `jekyll` gem:

    $ gem install jekyll


### RVM: Bundler to manage `Gemfile`s

Install the [Bundler](http://bundler.io/) gem that will be used to process `Gemfile`s and such:

    $ gem install bundler

From the site's main directory (where the `Gemfile` is), you can then run the following command to install all of the listed gems:

    $ bundle install


## Install Node.js

Parts of Jekyll also require Node.js to be available on the path. Install it from the Ubuntu packages, as follows:

    $ sudo apt-get install nodejs


## Serve the Site Locally

Run this to start a local server at <http://localhost:4000/karl/>:
s
    $ rvm 2.2.1@jekyll
    $ bundle exec jekyll serve --drafts

## Deploy the site to `eddings`

Run the following command to build the site and publish it to <https://justdavis.com/karl/>:

    $ ./dev/build-and-deploy.sh

