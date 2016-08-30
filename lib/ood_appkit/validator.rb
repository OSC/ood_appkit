module OodAppkit
  class Validator
    # Deserialize a validator object from JSON
    # @param object [Hash{#to_sym=>Object}] hash used defining context
    # @return [self] deserialized object
    def self.json_create(object)
      new object["data"].each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end

    def initialize(**_)
    end

    # Whether this validation was successful
    # @return [Boolean] whether successful
    def success?
      true
    end

    # Whether this validation was a failure
    # @return [Boolean] whether failure
    def failure?
      !success?
    end
  end
end
