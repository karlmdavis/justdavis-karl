--- 
title: Karl's Blog
kind: topic
summary: Karl's Blog
---

# Karl's Blog

<% oldest_item = nil %>
<% current_index = 0 %>

<% sorted_articles[current_index, featured_count].each do |item| %>
<%   oldest_item = item %>
<%   current_index += 1 %>
<%=  render('_article', :item => item, :is_embedded => true) %>
<% end %>

<% sorted_articles[current_index, excerpt_count].each do |item| %>
<%   oldest_item = item %>
<%=  render('_excerpt', :item => item) %>
<% end %>
                
<%= render('_other_articles_nav', :reference_item => oldest_item, :older_only => true) %>

