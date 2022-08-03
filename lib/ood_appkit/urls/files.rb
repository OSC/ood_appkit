module OodAppkit
  module Urls
    # A class used to handle URLs for the system Files app.
    class Files < Url
      # @param (see Url#initialize)
      # @param fs_url [#to_s] the URL used to request a filesystem view in the app
      # @param api_url [#to_s] the URL used to request the app's api
      def initialize(fs_url: '', api_url: '/api/v1', template: '{/url*}{/fs}{+path}', **kwargs)
        super(template: template, **kwargs)
        @fs_url  = parse_url_segments(fs_url.to_s)
        @api_url = parse_url_segments(api_url.to_s)
      end

      # URL to access this app for a given absolute file path
      # @param opts [#to_h] the available options for this method
      # @option opts [#to_s, nil] :path ("") The absolute path to the file on
      #   the filesystem
      # @option opts [#to_s, nil] :fs ("") The filesystem for the path
      # @return [Addressable::URI] absolute url to access path in file app
      def url(opts = {})
        opts = opts.to_h.compact.symbolize_keys

        path = opts.fetch(:path, "").to_s
        fs = opts.fetch(:fs, "fs").to_s
        @template.expand url: @base_url + @fs_url, fs: fs, path: path
      end

      # URL to access this app's API for a given absolute file path
      # @param opts [#to_h] the available options for this method
      # @option opts [#to_s, nil] :path ("") The absolute path to the file on
      #   the filesystem
      # @option opts [#to_s, nil] :fs ("") The filesystem for the path
      # @return [Addressable::URI] absolute url to access path in files app api
      def api(opts = {})
        opts = opts.to_h.compact.symbolize_keys

        path = opts.fetch(:path, "").to_s
        fs = opts.fetch(:fs, "fs").to_s
        @template.expand url: @base_url + @api_url, fs: fs, path: path
      end
    end
  end
end
