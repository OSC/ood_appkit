require 'ood_cluster'

module OodAppkit
  # A decorator that adds a presentation layer to the {OodCluster::Cluster} object
  class ClusterDecorator < SimpleDelegator
    # The identifier used as the key in the OodAppkit clusters hash (used for
    # reverse searching)
    # @return [Symbol] the clusters hash key for this object
    attr_reader :id

    # The title used to describe this cluster to users
    # @return [String] the cluster title
    attr_reader :title

    # The URL for this cluster that users can use to view more information
    # @return [String] the cluster url
    attr_reader :url

    # @param cluster [OodCluster::Cluster] cluster object
    # @param id [#to_sym] id used in clusters hash of OodAppkit
    # @param title [#to_s] title of cluster
    # @param url [#to_s] url of cluster
    # @param validators [Hash{#to_sym=>Array<Validator>}] hash of validators
    def initialize(cluster:, id:, title: "", url: "", validators: {}, **_)
      super(cluster)
      @id         = id.to_sym
      @title      = title.to_s
      @url        = url.to_s
      @validators = validators.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end

    # Whether the given method is valid (i.e., passes all supplied validators)
    # @param method [#to_sym] method to check if valid
    # @return [Boolean] whether this method is valid
    def valid?(method = :cluster)
      @validators.fetch(method.to_sym, []).all? { |v| v.success? }
    end

    # The comparison operator
    # @param other [#to_sym] object to compare against
    # @return [Boolean] whether objects are equivalent
    def ==(other)
      id == other.to_sym
    end
  end
end
