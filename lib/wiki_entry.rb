# encoding: utf-8

def wiki_entries()
  entries = @items
  entries = entries.select { |item| item[:kind] == 'wikientry' }

  entries
end

def wiki_entry_link(entry)
  if entry.is_a?(String)
    entry = @items.find { |item| item.identifier == entry }
  end

  raise ArgumentError, "Cannot create a link to #{entry.inspect} because it is not of :kind 'wikientry': #{entry[:kind]}." if entry[:kind] != 'wikientry'
  
  link_to(entry[:title], entry)
end

module Nanoc3::DataSources

  class WikiEntries < Nanoc3::DataSource

    identifier :wiki_entries

    include Nanoc3::DataSources::Filesystem

    # See {Nanoc::DataSource#setup}.
    def setup
      # Create directory
      %w( wikientries ).each do |dir|
        FileUtils.mkdir_p(dir)
        vcs.add(dir)
      end
    end

    # See {Nanoc::DataSource#items}.
    def items
      objects = load_objects('wikientries', 'item', Nanoc3::Item)
      objects.each do |item|
        item[:title] = item.identifier.split("/").last
        item[:kind] = 'wikientry'
      end
      
      return objects
    end

    # See {Nanoc3::DataSource#create_item}.
    def create_item(content, attributes, identifier, params={})
      create_object('wikientries', content, attributes, identifier, params)
    end

    # See {Nanoc::DataSource#layouts}.
    def layouts
      []
    end

  private

    # See {Nanoc3::DataSources::Filesystem#create_object}.
    def create_object(dir_name, content, attributes, identifier, params={})
      # Check for periods
      if (@config.nil? || !@config[:allow_periods_in_identifiers]) && identifier.include?('.')
        raise RuntimeError,
          "Attempted to create an object in #{dir_name} with identifier #{identifier} containing a period, but allow_periods_in_identifiers is not enabled in the site configuration. (Enabling allow_periods_in_identifiers may cause the site to break, though.)"
      end

      # Determine path
      ext = params[:extension] || '.html'
      path = dir_name + (identifier == '/' ? '/index.html' : identifier[0..-2] + ext)
      parent_path = File.dirname(path)

      # Notify
      Nanoc3::NotificationCenter.post(:file_created, path)

      # Write item
      FileUtils.mkdir_p(parent_path)
      File.open(path, 'w') do |io|
        meta = attributes.stringify_keys
        unless meta == {}
          io.write(YAML.dump(meta).strip + "\n")
          io.write("---\n\n")
        end
        io.write(content)
      end
    end

    # See {Nanoc3::DataSources::Filesystem#filename_for}.
    def filename_for(base_filename, ext)
      if ext.nil?
        nil
      elsif ext.empty?
        base_filename
      else
        base_filename + '.' + ext
      end
    end

    # Returns the identifier derived from the given filename, first stripping
    # the given directory name off the filename.
    def identifier_for_filename(filename)
      if filename =~ /(^|\/)index\.[^\/]+$/
        regex = ((@config && @config[:allow_periods_in_identifiers]) ? /\/?index\.[^\/\.]+$/ : /\/?index\.[^\/]+$/)
      else
        regex = ((@config && @config[:allow_periods_in_identifiers]) ? /\.[^\/\.]+$/         : /\.[^\/]+$/)
      end
      '/wiki' + filename.sub(regex, '').cleaned_identifier
    end

  end

end

module Nanoc3::Filters

  # Converts Trac Wiki format to Markdown format (more or less).
  class TracWikiFilter < Nanoc3::Filter
    identifier :tracwiki
    type :text

    def run(content, params={})
      content = content.gsub('nanoc sucks', 'nanoc rocks')

      # Headers
      content = content.gsub(/====\s(.+?)\s====/, '#### \1')
      content = content.gsub(/===\s(.+?)\s===/, '### \1')
      content = content.gsub(/==\s(.+?)\s==/, '## \1')
      content = content.gsub(/=\s(.+?)\s=/, '# \1')
      
      # Code Blocks
      content = content.gsub(/\{\{\{([^\n]+?)\}\}\}/, '<code>\1</code>')
      content = content.gsub(/\{\{\{(.+?)\}\}\}/m, '<pre><code>\1</code></pre>')

      # Links
      #content.gsub(/\[(http[^\s\[\]]+)\s([^\[\]]+)\]/, '"\2":\1')
      #content.gsub(/\[([^\s]+)\s(.+)\]/, '"\2":' + GITHUB_WIKI_URL + '\1')
      #content.gsub(/([^"\/\!])(([A-Z][a-z0-9]+){2,})/, '\1[[\2]]')

      # Remove ! characters from explicitly-not-wiki-links
      content = content.gsub(/!(([A-Z][a-z0-9]+){2,})/, '\1')

      # Wiki CamelCase Links
      content = content.gsub(/(([A-Z][a-z0-9]+){2,})/) do
        linked_item_id = '/wiki/' + $1 + "/"
        linked_item = @items.find { |item| item.identifier == linked_item_id }

        if linked_item.nil?
          $1
        else
          Nanoc3::Helpers::LinkTo.link_to($1, linked_item)
        end
      end

      # Font Styles
      content = content.gsub(/'''(.+)'''/, '**\1**') # bold
      content = content.gsub(/''(.+)''/, '*\1*') # italic

      # Remove leading space in lists
      content = content.gsub(/^\s\*/, '*')
      content = content.gsub(/^\s(\d\.)/, '\1')

      # Add line breaks before lists
      content = content.gsub(/\n([^\*][^\n]*\n)\*/m, "\\1\n*")
      content = content.gsub(/\n([^\d][^\.][^\n]*\n)(\d\.)/m, "\\1\n\\2")

      return content
    end
  end

end
