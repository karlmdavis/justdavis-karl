module Jekyll
  class CollectionDocUrl < Liquid::Tag
    @item_id = nil
    @properties

    PROP_SYNTAX = /(?<key>[\w-]+)\s*:\s*("(?<value_quoted>.+)"|(?<value>\S+))/
    ARGS_SYNTAX = /\s*("(?<item_id_quoted>.+)"|(?<item_id>\S+))( #{PROP_SYNTAX})*/

    def initialize(tag_name, args, tokens)
      super
      #Jekyll.logger.error "args: ", args
      #Jekyll.logger.error "tokens: ", tokens
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

    def render(context)
      site = context.registers[:site]

      site.collections.each do |_, collection|
        collection.docs.each do |doc|
          #Jekyll.logger.error "doc.id: ", doc.id
          if @item_id == doc.id
            if @properties["baseurl"]
              return site.baseurl + doc.url
            else
              return doc.url
            end
          end
        end
      end

      raise ArgumentError.new <<-eos
Could not find collection item with id "#{@item_id}" in tag 'collection_doc_url'.

Make sure the item exists and the id is correct.
eos
    end
  end
end

Liquid::Template.register_tag('collection_doc_url', Jekyll::CollectionDocUrl)

