--- 
title: Eddings Virtual Machines
kind: topic
summary: "Describes the steps necessary to make eddings a VM host."
---

# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a VM host.

This is necessary as the server will be replacing an ESXi server that hosted several old VMs. Until the services on these VMs are migrated onto `eddings`, the VMs will have to be hosted on `eddings` to ensure the services remain available. The VMs being migrated are the following:

* <%= wiki_entry_link("LewisSetup") %>
* <%= wiki_entry_link("AsimovSetup") %>
* `piers` (no documentation available)
* <%= wiki_entry_link("TolkienSetup") %>


## Selecting a VM Technology

In the past, I've primarily used [VirtualBox](https://www.virtualbox.org/) to host virtual machines. I've also recently had a bit of experience with [kvm](http://www.linux-kvm.org/page/Main_Page). While VirtualBox was pleasantly simple to use, I've had issues with guest stability on it in the past. In addition, kvm seems to be the most commonly recommended technology on Linux these days. It's also much easier to automate. Accordingly, I've opted to use kvm on this computer.


## Installing kvm

References:

* <https://help.ubuntu.com/community/KVM/Installation>

Run the following command to install kvm and related utilities on the server:

    # sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder virtinst bridge-utils

The `apt-cache show <package-name>` command can be used to view the description of each of those packages.

When prompted to choose the "Postfix Configuration", select **No configuration**.

After installation, you will need to log off and log back in to your user account before proceeding. This is necessary as the installation created a new `libvirtd` group that your user has been added to, but group membership is only updated on login. Run the `groups` command to view a list of the groups that your user is a member of.

Run the following command to verify that KVM is supported by your computer:

    $ kvm-ok

If it reports that KVM is supported, you're good, otherwise you'll have to use the slower QEMU. This rest of this guide does not cover QEMU; it assumes a computer that supports KVM.


## Enabling Bridged Networking

References:

* <https://help.ubuntu.com/community/KVM/Networking#Bridged_Networking>
* <https://help.ubuntu.com/community/BridgingNetworkInterfaces>

The default networking mode for `libvirt` VMs uses NAT, which prevents the VMs from being remotely accessible. As all of the VMs I'm setting up are servers, this won't work. The most common solution to this limitation is to configure the VMs to use bridged networking. In bridged networking mode, the VMs will have shared access to the VM host's physical NIC.

First, we must give `qemu` permissions to administer our machine's networking:

    $ sudo apt-get install libcap2-bin
    $ sudo setcap cap_net_admin=ei /usr/bin/qemu-system-x86_64

Edit the `/etc/network/interfaces` file on the VM host to create a bridge, as follows:

<pre><code>auto lo
iface lo inet loopback

# The public network's interface
auto eth0
iface eth0 inet manual
up ip link set eth0 up

# The bridge used by libvirt guests, runs on eth0 (the public network)
auto br0
iface br0 inet manual
        bridge_ports eth0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0

# The private network's interface
auto eth1
iface eth1 inet dhcp
</code></pre>

Then, restart the nwtorking service:

    sudo /etc/init.d/networking restart

Ensure that `eth1` has an IP address, and that `eth0` and `br0` don't by running `ifconfig`. In my case, they didn't. I resolved it by restarting the cable modem and then restarting networking again.


## Migrating VMs from ESXi


### Copying VM Files from ESXi Drive

References:

* <http://digfor.blogspot.com/2011/04/accessing-vmfs-partitions.html>

The `vmfs-fuse` mount application can be used to read the partition format used by ESXi to store virtual machine datastores.

Connect and mount the hard drive used by ESXi as a datastore. In my case, the drive's device node was `/dev/sda3`, which was a "VMware VMFS" partition (as reported by `fdisk -l`). This was mounted by doing the following:

    $ sudo apt-get install vmfs-tools
    $ sudo mkdir /mnt/esxi-vmfs
    $ sudo vmfs-fuse /dev/sda3 /mnt/esxi-vmfs

Copy the `.vmdk` and `.vmx` files from that datastore to the new server's drive:

    $ mkdir -p ~/eddings-vms/esxi
    $ sudo su
    # cp /mnt/esxi-vmfs/lewis/*.vmx /mnt/esxi-vmfs/asimov/*.vmx /mnt/esxi-vmfs/piers/*.vmx /mnt/esxi-vmfs/tolkien/*.vmx /home/localuser/eddings-vms/esxi/
    # cp /mnt/esxi-vmfs/lewis/*.vmdk /mnt/esxi-vmfs/asimov/*.vmdk /mnt/esxi-vmfs/piers-consolidated-2012-01-06/*.vmdk /mnt/esxi-vmfs/piers/*.vmdk /mnt/esxi-vmfs/tolkien/*.vmdk /home/localuser/eddings-vms/esxi/
    # chmod a+rw -R /home/localuser/eddings-vms/esxi/
    # exit

Unmount the ESXi datastore and clean up the now-unnecessary packages and mountpoint:

    $ sudo umount /mnt/esxi-vmfs
    $ sudo rmdir /mnt/esxi-vmfs
    $ sudo apt-get autoremove vmfs-tools


### Converting `.vmdk` Images to `.qcow2` Images

Once the `.vmdk` files have all been copied over, they should be converted to `.qcow2` files, which are better supported by KVM:

    $ mkdir ~/eddings-vms/libvirt
    $ qemu-img convert -O qcow2 ~/eddings-vms/esxi/lewis-flat.vmdk ~/eddings-vms/libvirt/lewis.qcow2
    $ qemu-img convert -O qcow2 ~/eddings-vms/esxi/piers-consolidated-flat.vmdk ~/eddings-vms/libvirt/piers.qcow2
    $ qemu-img convert -O qcow2 ~/eddings-vms/esxi/asimov-flat.vmdk ~/eddings-vms/libvirt/asimov-root.qcow2
    $ qemu-img convert -O qcow2 ~/eddings-vms/esxi/asimov_1-flat.vmdk ~/eddings-vms/libvirt/asimov-afs1.qcow2
    $ qemu-img convert -O qcow2 ~/eddings-vms/esxi/asimov_2-flat.vmdk ~/eddings-vms/libvirt/asimov-afs2.qcow2
    $ qemu-img convert -O qcow2 ~/eddings-vms/esxi/tolkien-flat.vmdk ~/eddings-vms/libvirt/tolkien.qcow2

Please note that this won't work at all if your VMs had snapshots. If they did, you'll need to fire up the ESXi server again, go into the VM's Snapshot Manager (in the vSphere Client), and click **Delete All**. I spent a long time trying to get around this necessity myself, but never did manage to; I had to bite the bullet and spin up ESXi again.

Finally, move the new `.qcow2` files to the `/var/lib/libvirt/images/` directory, where the image files are typically stored:

    $ sudo mv ~/eddings-vms/libvirt/*.qcow2 /var/lib/libvirt/images/
    $ sudo chown root:root /var/lib/libvirt/images/*.qcow2
    $ sudo chmod u=rw,g=,o= /var/lib/libvirt/images/*.qcow2


### Converting `.vmx` Definitions to `libvirt` Definitions
virt
References:

* <http://blog.mymediasystem.net/uncategorized/vmware-kvm-migration-guide/>
* <http://www.gossamer-threads.com/lists/gentoo/user/219466>

The `virt-goodies` package provides a `vmware2libvirt` application that will convert VMWare's `.vmx` virtual machine defintion files into the `.xml` format used by `libvirt`. `libvirt` is the virtualization abstraction layer that we'll use to manage KVM.

I ran the following commands to convert each of the virtual machines I was migrating:

    $ sudo apt-get install virt-goodies
    $ vmware2libvirt -f ~/eddings-vms/esxi/lewis.vmx > ~/eddings-vms/libvirt/lewis.xml
    $ vmware2libvirt -f ~/eddings-vms/esxi/piers.vmx > ~/eddings-vms/libvirt/piers.xml
    $ vmware2libvirt -f ~/eddings-vms/esxi/asimov.vmx > ~/eddings-vms/libvirt/asimov.xml
    $ vmware2libvirt -f ~/eddings-vms/esxi/tolkien.vmx > ~/eddings-vms/libvirt/tolkien.xml
    $ sudo apt-get autoremove virt-goodies

Each of the `.xml` files created will need to be edited, e.g. via `nano ~/eddings-vms/libvirt/lewis.xml`, to make the following changes:

* Add a new `<driver name='qemu' type='qcow2'/>` element to the `/domain/devices/disk` element.
* Change the `/domain/devices/disk/source` element's `file` attribute to point to the correct `.qcow2` file, e.g.: `<source file='/var/lib/libvirt/images/lewis.qcow2'/>`.
* Change the `/domain/devices/interface` element's `type` attribute to `'bridge'`, e.g. `<interface type='bridge'>`.
* Remove the `/domain/devices/interface/source` element's `network` attribute. In its place, set the `bridge` attribute to `'br0'`, e.g. `<source bridge='br0'/>`.

Once the files have been edited, the VMs can be registered with `libvirt` by running the `virsh ... define` command, as follows:

    $ sudo virsh -c qemu:///system define ~/eddings-vms/libvirt/lewis.xml
    $ sudo virsh -c qemu:///system define ~/eddings-vms/libvirt/piers.xml
    $ sudo virsh -c qemu:///system define ~/eddings-vms/libvirt/asimov.xml
    $ sudo virsh -c qemu:///system define ~/eddings-vms/libvirt/tolkien.xml

Please note that this creates the VM definition as a *copy* of the original `.xml` definition; the original `*.xml` files could be safely removed after these commands.


## Starting and Viewing VMs

Once the VMs have been defined, they can be "booted" using the `virsh ... start` command, e.g.:

    $ sudo virsh --connect qemu:///system start lewis

On a separate workstation (one with a graphical shell), the `virt-viewer` application can be used to view the VMs' consoles:

    $ sudo apt-get install virt-viewer
    $ virt-viewer --connect qemu+ssh://localuser@192.168.1.100/system --wait --reconnect lewis


## Managing VMs

References:

* <http://doc.ubuntu.com/ubuntu/serverguide/C/libvirt.html#virt-manager>

When possible, I recommend using the command line to manage virtual machines. It's faster (once you learn what you're doing) and much easier to document. However, the `virt-manager` GUI made that learning process much easier for me. You can install it by running the following command:

    # apt-get install virt-manager

