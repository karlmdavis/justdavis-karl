---
layout: it_doc
title:  "Eddings"
date:   2015-11-17 10:27:00
description: Describes the setup and configuration of eddings, my main server.
---

Blah blah IT stuff. Yay.

Subpages:

* {% assign eddings_tomcat = site.it_docs | where:"id","/it/eddings/eddings-tomcat" | first %} [{{ eddings_tomcat.title }}]({{ eddings_tomcat.url | prepend: site.baseurl }}): {{ eddings_tomcat.description }}

Subpages (auto):

{% assign subtopics = site.it_docs | where:"parent","eddings" %}
{% for subtopic in subtopics %}
* [{{ subtopic.title }}]({{ subtopic.url | prepend: site.baseurl }}): {{ subtopic.description }}
{% endfor %}

Subpages (plugin):

* [Link]({% collection_doc_url /it/eddings/eddings-tomcat baseurl:true foo:bar %}): < {% collection_doc_url /it/eddings/eddings-tomcat baseurl:true foo:bar %} >
* {% collection_doc_link /it/eddings/eddings-tomcat baseurl:true %}
* {% collection_doc_link_long /it/eddings/eddings-tomcat baseurl:true %}

Doc:

{{ eddings_tomcat }}
