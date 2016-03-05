---
title: Expanding Guest Drives on libvirt
layout: it_doc
description: "Describes how to expand the space available to a guest running on libvirt."
---

References:

* [libvirt Wiki: Increasing the disk size of a virtual machine](http://wiki.libvirt.org/page/Tips#Increasing_the_disk_size_of_a_virtual_machine)
* [Creating sparse files on Linux hosts with dd](http://prefetch.net/blog/index.php/2009/07/05/creating-sparse-files-on-linux-hosts-with-dd/)
* [man virt-resize - Resize a virtual machine disk](http://manpages.ubuntu.com/manpages/precise/en/man1/virt-resize.1.html)

This guide describes how to expand the space available to a guest running on libvirt. At a high-level, this requires the following steps:

1. Create an empty image at the new size desired for the disk.
1. Copy the old image file's data into the new image file, expanding the partitions inside the image during the copy.

Before doing any of this, though, the current disk image file needs to be located and its format determined. The following command will display the path to the disk image file for a guest named "`guestname`" on the local host computer:

    $ sudo virsh dumpxml guestname | xpath /domain/devices/disk/source/@file

The following command will display the format of the image file:

    $ sudo virsh dumpxml guestname | xpath /domain/devices/disk/source/../driver

If you're curious about what types of image formats are available, see the following reference: [QEMU Image Types](http://en.wikibooks.org/wiki/QEMU/Images#Image_types).


## RAW Format

If the `driver` element's `name` attribute is "`qemu`" and its "`type`" attribute is "`raw`", then the guest image file is in the "raw" format. If this is the case, we can use standard Linux commands to create the empty empty image that the old one's data will be copied into.

Creating an empty "raw" image is simple and can be done with either `dd` or `truncate`. Use `truncate` if you don't want the extra space to be [sparse](https://wiki.archlinux.org/index.php/Sparse_file#What_is_a_sparse_file.3F). The following command uses `truncate` to create a non-sparse empty image named `biggerdisk.raw` of 40 GB:

    $ truncate --size=+40G biggerdisk.raw

Alternatively, the following command uses `dd` to create a sparse empty file named `biggerdisk.raw` of 40 GB:

    $ dd if=/dev/zero of=biggerdisk.raw bs=1 count=0 seek=40G

Next, use the `virt-filesystems` command to display the internal partition structure of the old image file (replace the full `guestname.raw` path with the one found earlier):

    $ sudo virt-filesystems --long --parts --blkdevs -h -a /var/lib/libvirt/images/guestname.raw

Based on the output of this command, select which partition should receive the extra space being created. For example, the following might be output for an 8 GB disk where the `/dev/sda2` partition ought to be expanded:

~~~~
Name       Type       Size  Parent
/dev/sda1  partition  101M  /dev/sda
/dev/sda2  partition  7.9G  /dev/sda
/dev/sda   device     8.0G  -
~~~~

Once that's determined, the `virt-resize` command can be used to copy the old image's data into the new, larger image, and expand the selected partition. For example, the following command will copy data from `/var/lib/libvirt/images/guestname.raw` into the new `biggerdisk.raw` image created earlier, expanding the `dev/sda2` partition:

    $ virt-resize --expand /dev/sda2 /var/lib/libvirt/images/guestname.raw biggerdisk.raw

After that, all the remains to be done is to replace the old image file with the new one:

    $ sudo chown root:root biggerdisk.raw
    $ sudo chmod u=rw,g=r,o=r biggerdisk.raw
    $ sudo mv /var/lib/libvirt/images/guestname.raw /var/lib/libvirt/images/guestname-beforeResize.raw
    $ sudo mv biggerdisk.raw /var/lib/libvirt/images/guestname.raw

Once the virtual machine has been booted and it's verified that the resize operation worked correctly, the old image file can be removed:

    $ sudo rm /var/lib/libvirt/images/guestname-beforeResize.raw

