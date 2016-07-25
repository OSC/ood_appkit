module OodAppkit
  module Urls
    # A class used to handle URLs for the system file Editor app.
    class Editor < Url
      # @param (see Url#initialize)
      # @param edit_url [#to_s] the URL used to request the file editor api
      def initialize(edit_url: '/edit', template: '{/url*}{+path}', **kwargs)
        super(template: template, **kwargs)
        @edit_url = parse_url_segments(edit_url.to_s)
      end

      # URL to access this app's file editor API for a given absolute file path
      # @param path [#to_s] the absolute path to the file on the filesystem
      # @return [Addressable::URI] absolute url to access path in file editor api
      def edit(path: '')
        @template.expand url: @base_url + @edit_url, path: path.to_s
      end
    end
  end
end
