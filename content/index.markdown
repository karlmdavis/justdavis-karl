--- 
title: Davis Family IT
kind: topic
summary: Main documentation page.
---

# IT Documentation

This site contains the IT documentation for the `davisonlinehome.name` intranet. The site is organized as a series of hierarchical topics, generally grouped by the various devices on the network.

The content from the old Trac wiki that was previously used to house this content can be found on <%= topic_link("/wiki/") %>.

## Categories

### Servers
<ul>
<% topics("/servers/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>

<!--
### Workstations
<ul>
<% topics("/workstations/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>
-->

### Applications
<ul>
<% topics("/applications/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>

<!--
### Miscellaneous
<ul>
<% topics("/misc/").each do |topic| %>
  <li><%= topic_summary_link(topic) %></li>
<% end %>
</ul>
-->

<!--
<h2>Top-Level Topics</h2>
<ul>
<% topics("/").each do |topic| %>
  <li><%= topic.identifier %></li>
<% end %>
</ul>

## Root Children
<ul>
<% @items.find { |item| item.identifier == "/" }.children.each do |item| %>
  <li><%= item.identifier %></li>
<% end %>
</ul>

## Items
<ul>
<% @items.each do |item| %>
  <li>inspect=<%= item.inspect %>, id=<%= item.identifier %>, kind=<%= item.respond_to?('kind') %></li>
<% end %>
</ul>
-->
