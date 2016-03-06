---
title: Feist Virtual Machines
parent: /it/feist
layout: it_doc
description: Describes the steps necessary to make feist a VM host.
---

This {% collection_doc_link /it/feist baseurl:true %} sub-guide describes the steps necessary to make the computer a VM host.

The VM host will be used to run the following virtual machines:
* {% collection_doc_link_long /it/paolini baseurl:true %}


## Selecting a VM Technology

In the past, I've primarily used [VirtualBox](https://www.virtualbox.org/) to host virtual machines. I've also recently had a bit of experience with [kvm](http://www.linux-kvm.org/page/Main_Page). While VirtualBox was pleasantly simple to use, I've had issues with guest stability using it in the past. In addition, kvm seems to be the most commonly recommended technology on Linux these days. It also seems to be easier to automate. Accordingly, I've opted to use kvm on this computer.


## Installing kvm

References:

* <https://help.ubuntu.com/community/KVM/Installation>

Run the following command to install kvm and related utilities:

    # sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder virtinst bridge-utils virt-viewer

The `apt-cache show <package-name>` command can be used to view the description of each of those packages.

After installation, you will need to log off and log back in to your user account before proceeding. This is necessary as the installation create a new `libvirtd` group that your user has been added to, but group membership is only updated on login. Run the `groups` command to view a list of the groups that your user is a member of.


## Managing VMs

References:

* <http://doc.ubuntu.com/ubuntu/serverguide/C/libvirt.html#virt-manager>

When possible, I recommend using the command line to manage virtual machines. It's faster (once you learn what you're doing) and much easier to document. However, the `virt-manager` GUI made that learning process much easier for me. You can install it by running the following command:

    # apt-get install virt-manager

