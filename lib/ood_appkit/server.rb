module OodAppkit
  # An object that describes a server hosted by a given cluster
  class Server
    # The host information for this server object
    # @example Host information for login node
    #   "my_server.host" #=> "oakley.osc.edu"
    # @return [String] the host for this server
    attr_reader :host

    # @param host [String] host info
    def initialize(host:, **_)
      @host = host
    end
  end
end
