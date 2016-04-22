module OodApp
  class ShellApp
    attr_accessor :base_url

    def self.default_base_url
      '/pun/sys/shell'
    end

    def initialize(url)
      @base_url = url
    end

    def url(path:"", host: "default")
      if path.nil? || path == ""
        join_relative_uris(base_url, "ssh", host)
      else
        join_relative_uris(base_url, "ssh", host, path)
      end
    end

    # FIXME: refactor - a URI subclass, for example; OODApp::URI
    private

    # normalize the pathname so it can be appended at the end of a URL
    def normalize(path)
      # TODO: if we want to support running on Windows nodes,
      # file system path must be updated so we can use it in a URL

      # coerce to string so we can handle Pathnames, Strings, URIs, etc.
      path ? URI.encode(path.to_s) : ""
    end

    def join_relative_uris(*uris)
      # TODO: do we need to be concerned about windows, \, etc.?
      File.join(uris.map(&:to_s))
    end
  end
end
