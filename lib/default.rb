# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Breadcrumbs
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::HTMLEscape
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Text
include Nanoc3::Helpers::XMLSitemap

def topics_broken(parent_topic)
  if parent_topic.is_a?(String)
    parent_topic = @items.find { |item| item.identifier == parent_topic }
  end

  topics = @items
  topics = topics.select { |item| item[:kind] == 'topic' }
  topics = topics.select { |topic| topic.parent == parent_topic }

  topics
end

def topics(parent_topic_id)
  if parent_topic_id.end_with?("/")
    parent_topic_id = parent_topic_id.chop
  end

  topics = @items
  topics = topics.select { |item| item[:kind] == 'topic' }
  #topics = topics.select { |topic| topic.identifier == (parent_topic_id + topic.identifier.split("/").last) }
  topics = topics.select { |topic| Pathname.new(topic.identifier).parent == Pathname.new(parent_topic_id) }

  topics
end

def topic_link(topic)
  raise ArgumentError, "Cannot create a link to #{topic.inspect} because it is not of :kind 'topic'." if topic[:kind] != 'topic'
  
  link_to(topic[:title], topic)
end

def topic_summary_link(topic)
  if topic.is_a?(String)
    topic = @items.find { |item| item.identifier == topic }
  end

  raise ArgumentError, "Cannot create a link to #{topic.inspect} because it is not of :kind 'topic'." if topic[:kind] != 'topic'
  
  @result = link_to_topic(topic)
  if not topic[:summary].nil? 
    @result = @result + ": " + topic[:summary]
  end

  @result
end

