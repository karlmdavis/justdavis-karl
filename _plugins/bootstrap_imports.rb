require "bootstrap"

module Jekyll
  module Converters
    # Override / monkey patch Jekyll's built-in `Scss` class to customize its behavior.
    class Scss < Converter

      def sass_load_paths_with_bootstrap
        # Add in the Bootstrap SCSS path from the bootstrap gem.
        paths = sass_load_paths_default
        paths << Bootstrap.stylesheets_path

        paths
      end

      # Copy the original :sass_load_paths to an alias.
      alias_method :sass_load_paths_default, :sass_load_paths

      # Set our bootstrap-including override as the new "default" version of the method.
      alias_method :sass_load_paths, :sass_load_paths_with_bootstrap
    end
  end
end
