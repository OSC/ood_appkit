module OodApp
  class FilesApp
    attr_accessor :base_url, :base_api_url, :base_fs_url

    def self.default_base_url
      '/pun/sys/files'
    end

    def initialize(url)
      @base_url = normalize(url)

      #FIXME: all of these should be configurable via ENV VARS
      @base_fs_url = join_relative_uris(base_url, "/fs")
      @base_api_url = join_relative_uris(base_url, "/api/v1/fs")
    end

    # return url that will provide html representations of the 
    # file system resource specified by the file system path (i.e. the cloudcmd
    # interface)
    def url(path: "")
      if path == ""
        join_relative_uris(base_url, normalize(path))
      else
        join_relative_uris(base_fs_url, normalize(path))
      end
    end

    # return url that will provide json or content representations of the 
    # file system resource specified by the file system path
    def api(path: "")
      join_relative_uris(base_api_url, normalize(path))
    end


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
