--- 
title: Davis Family IT
kind: topic
summary: Main documentation page.
---

# IT Documentation

This site contains the IT documentation for various devices and networks I've worked on. The site is organized as a series of hierarchical topics, with the top-level topics listed below.

Please note that my earlier IT documentation efforts made use of a Trac site that is no longer available. The wiki content of that site is hosted here at <%= topic_link("/it/davis/legacy-wiki/") %>.

## Servers
<ul>
<% topics("/it/davis/servers/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>

## Workstations
<ul>
<% topics("/it/davis/workstations/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>

## Miscellaneous
<ul>
<% topics("/it/davis/misc/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>

