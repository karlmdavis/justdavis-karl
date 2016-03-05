---
title: Fforde
layout: it_doc
group: workstations
description: Describes the setup of fforde, which is Erica's EeePC 900A Linux laptop.
---

`fforde` is Erica's EeePC 900A Linux laptop. The original setup documentation for `fforde` is archived at <%= wiki_entry_link("FfordeSetup") %>. This page documents everything done since then to configure `fforde`.


## Specs

* Hardware
    * CPU: Intel 1.6GHz Atom N270
    * Hard Drive: 4GB SSD
    * WLAN: 802.11b/g
    * Display: 8.9", 1024x600
    * Display Card: Intel UMA
    * Weight: 0.99kg


## Setup

Please see the following sub-guides:

{% assign sub_docs = site.it_docs | where:"parent","/it/fforde" %}
{% for sub_doc in sub_docs | sort:"date" %}
* {% collection_doc_link_long {{sub_doc.id}} baseurl:true %}</p>
{% endfor %}

