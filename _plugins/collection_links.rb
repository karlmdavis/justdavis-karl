module Jekyll
  class CollectionTag < Liquid::Tag
    attr_reader :item_id
    attr_reader :properties

    PROP_SYNTAX = /(?<key>[\w-]+)\s*:\s*("(?<value_quoted>.+)"|(?<value>\S+))/
    ARGS_SYNTAX = /\s*("(?<item_id_quoted>.+)"|(?<item_id>\S+))( #{PROP_SYNTAX})*/

    def parse_liquid_args(args)
      #Jekyll.logger.error "args: ", args
      args_parser = ARGS_SYNTAX.match(args)
      raise ArgumentError.new("Unable to parse args: '#{args}'") unless args_parser
      #Jekyll.logger.error "args_parser: .names: #{args_parser.names}, .captures: #{args_parser.captures}"
      @item_id = args_parser[:item_id].nil? ? args_parser[:item_id_quoted] : args_parser[:item_id]
      #Jekyll.logger.error "item_id: ", @item_id
      @properties = {}
      args.scan(PROP_SYNTAX).each do |prop_match|
        #Jekyll.logger.error "prop_match: #{prop_match[0]}, #{prop_match[1]}, #{prop_match[2]}"
        key = prop_match[0].nil? ? prop_match[1] : prop_match[0]
        @properties[key] = prop_match[2]
      end
      #Jekyll.logger.error "properties: ", @properties
    end
    
    def retrieve_item_id(context)
      if /\{\{([\w\-\.]+)\}\}/ =~ @item_id
        raise ArgumentError.new("No variable #{$1} was found in tag") if context[$1].nil?
        @item_id = context[$1]
      end
    end

    def find_doc(context)
      # If the Item ID is '{{some_variable}}', deref the variable.    
      retrieve_item_id(context)
      
      site = context.registers[:site]

      site.collections.each do |_, collection|
        collection.docs.each do |doc|
          #Jekyll.logger.error "doc.id: ", doc.id
          if @item_id == doc.id
            if @properties["baseurl"]
              return doc
            end
          end
        end
      end

      raise ArgumentError.new <<-eos
Could not find collection document with id "#{@item_id}".

Make sure the item exists and the id is correct.
eos
    end

    def build_doc_url(context, doc)
      if @properties["baseurl"]
        site = context.registers[:site]
        return site.baseurl + doc.url
      else
        return doc.url
      end
    end
  end

  class CollectionDocUrl < CollectionTag
    def initialize(tag_name, args, tokens)
      super
      parse_liquid_args(args)
    end

    def render(context)
      doc = find_doc(context)
      return build_doc_url(context, doc)
    end
  end

  class CollectionDocShortLink < CollectionTag
    def initialize(tag_name, args, tokens)
      super
      parse_liquid_args(args)
    end

    def render(context)
      doc = find_doc(context)
      url = build_doc_url(context, doc)
      #Jekyll.logger.error "doc.data: #{doc.data}"
      title = doc['title']
     
      return "<a href='url'>#{title}</a>"
    end
  end

  class CollectionDocLongLink < CollectionTag
    def initialize(tag_name, args, tokens)
      super
      parse_liquid_args(args)
    end

    def render(context)
      doc = find_doc(context)
      url = build_doc_url(context, doc)
      #Jekyll.logger.error "doc.data: #{doc.data}"
      title = doc['title']
      description = doc['description']
     
      return "<a href='url'>#{title}</a>: #{description}"
    end
  end
end

Liquid::Template.register_tag('collection_doc_url', Jekyll::CollectionDocUrl)
Liquid::Template.register_tag('collection_doc_link', Jekyll::CollectionDocShortLink)
Liquid::Template.register_tag('collection_doc_link_long', Jekyll::CollectionDocLongLink)

