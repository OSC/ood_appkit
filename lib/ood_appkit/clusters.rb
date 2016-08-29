module OodAppkit
  # An enumerable that holds a list of {ClusterDecorator} objects
  class Clusters
    include Enumerable

    # @param clusters [Array<ClusterDecorator>] list of cluster decorator objects
    def initialize(clusters = [])
      @clusters = clusters
    end

    # Find object in list from object's id
    # @param id [Object] id of cluster decorator object
    # @return [ClusterDecorator, nil] object if found
    def [](id)
      @clusters.detect { |v| v == id }
    end

    # Iterate over each of the clusters
    # @yield [obj] cluster decorator objects
    def each(&block)
      @clusters.each(&block)
    end
  end
end
