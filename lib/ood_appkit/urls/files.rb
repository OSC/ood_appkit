module OodAppkit
  module Urls
    # A class used to handle URLs for the system Files app.
    class Files < Url
      # @param (see Url#initialize)
      # @param fs_url [#to_s] the URL used to request a filesystem view in the app
      # @param api_url [#to_s] the URL used to request the app's api
      def initialize(fs_url: '/fs', api_url: '/api/v1/fs', template: '{/url*}{+path}', **kwargs)
        super(template: template, **kwargs)
        @fs_url  = parse_url_segments(fs_url.to_s)
        @api_url = parse_url_segments(api_url.to_s)
      end

      # URL to access this app for a given absolute file path
      # @param path [#to_s] the absolute path to the file on the filesystem
      # @return [Addressable::URI] absolute url to access path in files app
      def url(path: '')
        @template.expand url: @base_url + @fs_url, path: path.to_s
      end

      # URL to access this app's API for a given absolute file path
      # @param path [#to_s] the absolute path to the file on the filesystem
      # @return [Addressable::URI] absolute url to access path in files app api
      def api(path: '')
        @template.expand url: @base_url + @api_url, path: path.to_s
      end
    end
  end
end
