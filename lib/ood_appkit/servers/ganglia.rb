module OodAppkit
  module Servers
    # This defines a Ganglia server and defining parameters
    class Ganglia < Server
      # Template used to describe URI
      # @see https://www.rfc-editor.org/rfc/rfc6570.txt RFC describing template format
      TEMPLATE = '{+scheme}{host}{/segments*}{?query*}'

      # The scheme of the URI
      # @example Scheme of SSL protocol
      #   "my_ganglia.scheme" #=> "https://"
      # @return [String] scheme of uri
      attr_reader :scheme

      # The segments used to describe the path of the URI
      # @example Segments for URI with path "/ganglia/gweb.php"
      #   "my_ganglia.segments"
      #   #=> ["ganglia", "gweb.php"]
      # @return [Array<String>] segments of uri
      attr_reader :segments

      # The required query values of the URI
      # @example Required cluster query value
      #   "my_ganglia.query"
      #   #=> {c: "MyCluster"}
      # @return [Hash] required query values of uri
      attr_reader :query

      # Optional query values of the URI, these query values are
      # only defined if specified
      # @return [Hash] optional query values of uri
      attr_reader :opt_query

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # @param scheme [String] the scheme used for URI
      # @param segments [Array<String>] the segments used to
      #   construct path of URI
      # @param query [Hash] hash of query values used for
      #   URI
      # @param opt_query [Hash] hash of optional query
      #   values if they exist
      # @param version [String] version of server software
      def initialize(scheme:, segments: [], query: {}, opt_query: {}, version:, **kwargs)
        super(kwargs)

        # uri
        @scheme = scheme
        @segments = segments
        @query = query
        @opt_query = opt_query

        # version
        @version = version
      end

      # The full hash of query values used to construct URI
      # @param other_query [Hash] user specified query hash
      # @return [Hash] full hash of query values
      def query_values(other_query)
        query.merge(
          other_query.each_with_object({}) do |(k, v), h|
            h[k] = opt_query.has_key?(k) ? (opt_query[k] % query.merge(other_query)) : v
          end
        )
      end

      # The URI used to access information about given cluster
      # @param query_values [Hash] user specified query hash
      # @return [Addressable] the uri for ganglia server
      def uri(query_values: {})
        Addressable::Template.new(TEMPLATE).expand({
          scheme: scheme,
          host: host,
          segments: segments,
          query: query_values(query_values)
        })
      end
    end
  end
end
