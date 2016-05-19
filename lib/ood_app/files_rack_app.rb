module OodApp
  # Middleware that serves entries below the `root` given, according to the
  # path info of the Rack request.
  # @see http://www.rubydoc.info/github/rack/rack/master/Rack/Directory Descripton of `Rack::Directory`
  class FilesRackApp
    attr_accessor :route_path
    attr_accessor :route_helper

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
