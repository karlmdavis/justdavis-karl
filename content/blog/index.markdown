--- 
title: Karl's Blog
kind: topic
summary: Karl's Blog
---

# Karl's Blog

<% oldest_item = nil %>
<% current_index = 0 %>

<div id="articleExcerpts">
<% sorted_articles[current_index, excerpt_count].each do |item| %>
<%   oldest_item = item %>
<%=  render('_excerpt', :item => item) %>
<% end %>
</div>

<%= render('_other_articles_nav', { :reference_item => oldest_item, :older_only => true }) %>
<p>All articles can be found in the <%= topic_link("/blog/archives/") %>.</p>

