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

      # @param prefix [String] uri for ganglia server
      # @param version [String] version of client software
      def initialize(uri:, version:, **kwargs)
        super(kwargs)

        # uri
        @uri = Addressable::URI.parse uri

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
