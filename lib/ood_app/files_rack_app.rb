module OodApp
  # Middleware that serves entries below the `root` given, according to the
  # path info of the Rack request.
  # @see http://www.rubydoc.info/github/rack/rack/master/Rack/Directory Descripton of `Rack::Directory`
  class FilesRackApp
    # The routes path used for this rack app
    # @return [String] the routes path
    attr_accessor :route_path

    # The routes helper used for this route
    # @return [String] the routes helper
    attr_accessor :route_helper

    # @param route_path [String] the routes path for this rack app
    # @param route_helper [String] the helper used in the routes
    def initialize(route_path: '/files', route_helper: 'files')
      @route_path   = route_path
      @route_helper = route_helper
    end

    # Use `Rack::Directory` as middleware with `root` set as `dataroot`
    def call(env)
      Rack::Directory.new(OodApp.dataroot).call(env)
    end
  end
end
