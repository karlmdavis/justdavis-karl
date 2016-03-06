# Development Environment Setup: `justdavis.com/karl`

This document details the setup for the tools used to develop the `justdavis.com` site. This site is primarily managed via [Jekyll](http://jekyllrb.com/), a static site generator.


## Install RVM and Ruby 2

References:

* [Installing RVM](https://rvm.io/rvm/install)

Ubuntu Trusty ships with Ruby 1.9, while Jekyll requires Ruby 2. Upgrading the system's default Ruby version is a terrible idea that could break all sorts of other things, so instead, [RVM](https://rvm.io/) will be used to manage user-local versions of the Ruby tooling.

First, import the RVM signing key:

    $ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

Install RVM along with the latest stable Ruby release:

    $ \curl -sSL https://get.rvm.io | bash -s stable --ruby

At this point, RVM is installed and its shell functions are available for new shells. To load those functions into already-open terminal sessions, you can run the folloing command in each:

    $ source /home/karl/.rvm/scripts/rvm

The following commands can be used to list the installed Ruby versions, and activate one of them:

    $ rvm list
    
    rvm rubies
    
    =* ruby-2.2.1 [ x86_64 ]
    
    # => - current
    # =* - current && default
    #  * - default
    
    $ rvm use 2.2.1


### RVM: Gemset for Jekyll

It's expected that different combinations of Ruby gems will be needed for different tasks. Accordingly, RVM supports the concept of "gemsets": named bundles of installed gems. Create a "`jekyll`" gemset and activate it, as follows:

    $ rvm gemset create jekyll
    $ rvm 2.2.1@jekyll

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

    $ rvm 2.2.1@jekyll
    $ bundle exec jekyll serve

## Deploy the site to `eddings`

Run the following command to build the site and publish it to <https://justdavis.com/karl/>:

    $ ./dev/build-and-deploy.sh

