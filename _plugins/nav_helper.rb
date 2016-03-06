module Jekyll
  class NavActiveTag < Liquid::Tag
    ARGS_SYNTAX = /\s*('(?<target_quoted>.+)'|(?<target>\S+))/

    attr_reader :target

    def initialize(tag_name, args, tokens)
      super
      parse_liquid_args(args)
    end

    def parse_liquid_args(args)
      #Jekyll.logger.error "args: ", args
      args_parser = ARGS_SYNTAX.match(args)
      raise ArgumentError.new("Unable to parse args: '#{args}'") unless args_parser
      #Jekyll.logger.error "args_parser: .names: #{args_parser.names}, .captures: #{args_parser.captures}"
      @target = args_parser[:target].nil? ? args_parser[:target_quoted] : args_parser[:target]
      #Jekyll.logger.error "item_id: ", @item_id
    end

    def render(context)
      page_url = context.environments.first["page"]["url"]

      # The results to return.
      match_result_pos = "active"
      match_result_neg = ""

      # If the target ends with '/', we assume the match must be exact. If not, we'll match substrings.
      match_exact = @target.end_with?("/")

      if match_exact
        return page_url == @target ? match_result_pos : match_result_neg
      end

      return page_url.start_with?(@target) ? match_result_pos : match_result_neg
    end
  end
end

Liquid::Template.register_tag('nav_active', Jekyll::NavActiveTag)

