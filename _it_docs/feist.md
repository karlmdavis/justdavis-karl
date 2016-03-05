---
title: Feist
layout: it_doc
group: workstations
description: Describes the setup of feist, which is Karl's primary Linux desktop.
---

`feist` is Karl's primary Linux desktop. The original setup documentation for `feist` is archived at <%= wiki_entry_link("FeistSetup") %>. This page documents everything done since then to configure `feist`.


## Specs

* Hardware
    * RAM: 2 x 2048MB DDR2800 (PC2-6400)
        * G.Skill: F2-6400CL5D-4GBPQ
        * CL5-5-5-15
        * 1.8-1.9V
    * Motherboard: Gigabyte EP45-UD3P
    * Video Card: Sapphire ATI Radeon HD 3870
        * 512MB GDDR4
        * PCI-E
        * Dual DVI
    * CPU: E8400 Intel Core 2 Duo
        * 3 GHz
        * 45nm
        * 6MB L2 shared cache
        * LGA775 socket
        * 1333 MHz FSB
        * Product Code: BX80570E8400
        * MM #: 899035
        * FPO/Batch #: Q832A384
        * S-spec: SLB9J


## Setup

Please see the following sub-guides:

{% assign sub_docs = site.it_docs | where:"parent","/it/feist" %}
{% for sub_doc in sub_docs | sort:"date" %}
* {% collection_doc_link_long {{sub_doc.id}} baseurl:true %}</p>
{% endfor %}

