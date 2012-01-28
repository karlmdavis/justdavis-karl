--- 
title: All Tags
kind: topic
summary: All tags used in the blog.
is_hidden: true
---

# All Tags

<p>Listed are the set of tag links related to articles in this site. The number of articles related to a tag succeeds the tag.</p>
<% tags = count_tags() %>
<ul>
<% tags.sort_by{|k,v| k}.each do |tag_count| %>
	<% tag = tag_count[0] %>
	<% count = tag_count[1] %>
	<li><a href="/blog/tags/<%= tag %>/" class="tag"><%= tag %></a> x <%= count %></li>
<% end %>
</ul>

