---
title: Jordan
layout: it_doc
group: workstations
description: Describes the setup of jordan, which is Karl's primary Linux workstation.
---

`jordan` is Karl's primary Linux workstation. It is a Lenovo ThinkPad W530. The primary Linux install on the system is named `jordan-u`, and it also has a Windows 8 install on a separate drive named `jordan-w`. The Windows install isn't used often, but came with the workstation.


## Specs

* Hardware
    * Base System: [Lenovo ThinkPad W530](http://www.lenovo.com/products/us/tech-specs/laptop/thinkpad/w-series/w530/)
    * Processor: Intel Core i7-3740QM Processor (6M Cache, up to 3.70 GHz)
    * RAM: 32 GB of [204-Pin DDR3 SO-DIMM DDR3 1600 (PC3 12800)](http://www.newegg.com/Product/Product.aspx?Item=N82E16820231582)
    * Display: 15.6" FHD (1920 x 1080) LED Backlit AntiGlare Display
    * GPU: NVIDIA Quadro K1000M Graphics with 2GB DDR3 Memory
    * Camera: 720p HD Camera with Microphone
    * Hard Drives:
        * [SAMSUNG 840 Pro Series MZ-7PD256BW 2.5" 256GB SATA III MLC Internal Solid State Drive (SSD)](http://www.newegg.com/Product/Product.aspx?Item=N82E16820147193)
        * 320GB Hard Disk Drive, 7200rpm
            * Stored in a drive caddy that's used instead of the DVD drive
    * DVD Drive: DVD Recordable 8x Max, Dual Layer, Ultrabay Enhanced w/ SW Royalty for Windows 8
    * WiFi: Intel Centrino Ultimate-N 6300 AGN
    * Bluetooth: Bluetooth 4.0 with Antenna
    * System Expansion Slots: Express Card Slot & 4-in-1 Card Reader
    * Battery: 9 Cell Li-Ion TWL 70++
    * Power Cord: 170W Slim AC Adapter - US (2pin)
* Miscellaneous:
    * Purchased On: 2013-04-03
    * Warranty: 4YR Depot
    * Docking Station: [Lenovo 433835U ThinkPad Mini Dock Plus Series 3 with USB 3.0 - 170W](http://www.newegg.com/Product/Product.aspx?Item=N82E16834988293)


## Setup

The setup of this system is covered in the following sub-guides:

* `jordan-u`: Ubuntu Linux System
    {% assign sub_docs = site.it_docs | where:"parent","/it/jordan" %}{% for sub_doc in sub_docs | sort:"date" %}* {% collection_doc_link_long {{sub_doc.id}} baseurl:true %}
    {% endfor %}* {% collection_doc_link_long /it/netclients baseurl:true %}
    * {% collection_doc_link_long /it/keepass baseurl:true %}
    * {% collection_doc_link_long /it/chromium baseurl:true %}
    * {% collection_doc_link_long /it/tmux baseurl:true %}
    * {% collection_doc_link_long /it/git baseurl:true %}
    * {% collection_doc_link_long /it/nanoc-linux baseurl:true %}
    * {% collection_doc_link_long /it/java baseurl:true %}
    * {% collection_doc_link_long /it/maven baseurl:true %}
    * {% collection_doc_link_long /it/eclipse baseurl:true %}
    * {% collection_doc_link_long /it/android-dev-env baseurl:true %}
* `jordan-w`: Windows 8 System
    * No guides for this system have been written yet, as I haven't really used it at all.

