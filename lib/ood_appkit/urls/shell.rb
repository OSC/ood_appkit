module OodAppkit
  module Urls
    # A class used to handle URLs for the system Shell app.
    class Shell < Url
      # @param (see Url#initialize)
      # @param ssh_url [#to_s] the ssh URL used to access the terminal
      def initialize(ssh_url: '/ssh', template: '{/url*}/{host}{+path}', **kwargs)
        super(template: template, **kwargs)
        @ssh_url = parse_url_segments(ssh_url.to_s)
      end

      # URL to access this app for a given host and absolute file path
      # @param host [#to_s] the host the app will make an ssh connection with
      # @param path [#to_s] the absolute path to the directory ssh app opens up in
      # @return [Addressable::URI] the url used to access the app
      def url(host: 'default', path: '')
        @template.expand url: @base_url + @ssh_url, host: host.to_s, path: path.to_s
      end
    end
  end
end
