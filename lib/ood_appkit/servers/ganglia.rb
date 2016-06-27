module OodAppkit
  module Servers
    # This defines a Ganglia server and defining parameters
    class Ganglia < Server
      # The URI used to access information about given cluster
      # @return [Addressable] the uri for ganglia server
      attr_reader :uri

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # @param scheme [String] scheme component of URI
      # @param path [String] path component of URI
      # @param query_values [Hash<String>] hash of query values
      # @param version [String] version of server software
      def initialize(scheme:, path:, query_values: {}, version:, **kwargs)
        super(kwargs)

        # uri
        @uri = Addressable::URI.new({
          scheme: scheme,
          host: host,
          path: path,
          query_values: query_values
        })

        # version number
        @version = version
      end

      # Merge a hash of query values into this URI
      # NB: This doesn't alter the original URI
      # @param new_query_values [Hash] hash of query values
      # @return [Addressable] new uri with merged query values
      def merge_query_values(new_query_values)
        uri.dup.tap do |u|
          u.query_values = (uri.query_values || {}).merge(new_query_values)
        end
      end
    end
  end
end
