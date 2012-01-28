--- 
title: Blog Archives
kind: topic
summary: Blog Archives
---

# Blog Archives

<% articles_by_year_month.each do |year, month_h| %>
	<% month_h.each do |month, item_a| %>
<h2><%= "#{year} #{to_month_s(month)}" %></h2>
<ul id="blogArchives">
		<% item_a.each do |item| %>
	<li>
			<%= render('_excerpt', :item => item) %>
	</li>
		<% end %>
</ul>
	<% end %>
<% end %>

