--- 
title: "Puppet: First Impressions"
kind: article
publish: true
created_at: 2013/09/01
tags: [it, puppet]
excerpt: "Apache Maven is a wonderful tool for tracking, storing, and making use of compiled libraries, including native libraries (e.g. DLLs). Getting these libraries into Maven is simple."
---

After years of <%= topic_link("/it/", "obsessive IT documentation") %>, I've finally decided to start exploring the world of automated configuration management tools. I figured that if I'm going to spend all this time writing stuff down, I might as well make my documentation executable from the get-go. After a brief bit of research, I decided to try out [Puppet](https://puppetlabs.com/) first.

I've now been playing around with Puppet for a few months, using it to setup a build farm at work.


## The Good

### Manifests

I really like Puppet's (mostly) declarative configuration. Rather than saying "create a user named Bob", with Puppet, you simply say "a user named Bob is needed". The next time Puppet runs, Bob will be created if he doesn't exist. If the user already exists, but doesn't match the configuration specified, the user will be modified.

### Modules

Puppet manifests can be bundled up into modules, which can be reused and shared. There's a surprisingly large ecosystem of reuable modules available at [Puppet Forge](http://forge.puppetlabs.com/). It's nice not having to create everything from scratch. Even if none of the available modules meet your needs, they're all open source and a great source of examples.

### Documentation

The Puppet Labs folks have provided some of the [best documentation and tutorials](http://docs.puppetlabs.com/) I've encountered. These three resources alone will teach you pretty much everything you'll need to know about Puppet:

* [The Learning Puppet Series](http://docs.puppetlabs.com/learning): An excellent walkthrough of basic Puppet. My only complaint is that it hasn't quite kept pace with recent changes in Puppet best practices.
* [Hiera 1: Overview](http://docs.puppetlabs.com/hiera/1/): Covers most of the afore-mentioned gaps in Puppet's best practices. I just wish it was integrated into the "Learning Puppet" tutorials, as it took me a long time to wander across on my own. Hiera is absolutely essential to (and built-in to) using Puppet in a sane way.
* [Type Reference](http://docs.puppetlabs.com/references/latest/type.html): Not much to say; it's a reference. I use it all the time, though.


## The Bad

### Crufty Syntax

Though I do appreciate Puppet's manifests and modules, the syntax for them hasn't aged particularly well:

* Virtual resources are poorly explained and ugly.
* I have no idea why, but many of the modules I encounter in the wild have bizarre `Anchor`s scattered all over the place. Still haven't seen an explanation for them that made sense.
* No concept of resource merging: if one Puppet module declares a `foo` service, no other Puppet module may. Puppet will absolutely refuse to compile the configuration if there are any duplicates. I understand *why* this is, but I'm convinced there has to be a more elegant solution than Puppet currently has.

### Modules are Often Incomplete

As impressed as I am with how *many* Puppet modules there are, I have ended up being unable to use the vast majority of them for one reason or another: lack of OS support, lack of features, incompatibility with newer software, etc. So far, I've had to write from scratch or edit every single module I've used. Every single one.


## Lessons Learned

Problems aside, I could see myself sticking with Puppet. Here's a collection of random things I've learned that should make life easier:

### Modules Only

This one annoys me, but there really isn't any way to avoid it: all Puppet configuration needs to go into modules. It's often tempting to try and write node-specific manifests, but you will quickly run into a major problem: Puppet isn't setup (by default) to allow for this. A lot of Puppet configuration takes the form of static and templated configuration files. The only way to distribute these files (by default) is inside of modules. So, pretty much everything ends up in modules.

### Use Hiera, Not Manifests

The only thing my node/site manifests contain is the following line:

~~~~
# Pull the classes (and their configuration) for this node from Hiera
hiera_include('classes')
~~~~

This took me a while to figure out, but as mentioned above, Puppet really doesn't use manifests. They're still there, but they're practically deprecated. Everything these days is a combination of modules and Hiera. This is fine, I just wish the tutorials and documentation explained this. I had to figure it out for myself.

### Use Puppet Librarian

I actually just figured this one out today, and it's already immensely improved my opinion of Puppet. **Don't** install modules from Puppet Forge directly: use [Puppet Librarian](https://github.com/rodjek/librarian-puppet) instead.

Here's the thing: I can pretty much guarantee that every Puppet module you consider you using will only *almost* work for your use case, especially if you're in a mixed-OS environment. Even the best modules, like [puppetlabs/ntp](http://forge.puppetlabs.com/puppetlabs/ntp) and [rtyler/jenkins](https://forge.puppetlabs.com/rtyler/jenkins) lack wide OS support. As I'm currently using Puppet to setup a build and test farm, I need everything to support Ubuntu, RHEL, and Windows. Nothing does. Adding the missing support or features is often not a big deal, but I hadn't figured out how to go about doing it in a sane way until finding Librarian.

Librarian will check out/install modules right from their Git repositories. This is distinct from the typical installation mechanism, which just installs modules as a static bundle. Having them checked out from Git makes it possible to enhance the modules on your own, without sacrificing the ability to upgrade to later versions.

Unfortunately my current employer makes open sourcing any of my work output quite difficult. For anyone else, though, Librarian should also make it much easier to push improvements back to the original modules, improving the Puppet ecosystem.


## Conclusion

Overall, I think I might stick with Puppet. I do hope to start using it here at home, going forwards. While I hope that some of the problems above get addressed, I don't think any of them are show-stoppers.
