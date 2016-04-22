module OodApp
  module Configuration
    attr_accessor :dashboard_url, :files_url, :shell_url

    def configure
      yield self
    end

    # Return the configuration object.
    #
    # @return [Object] self The configuration object.
    def configure
      yield self
    end

    # Configuration Initializer
    #
    # Performs set_default_configuration on a base object and returns the configured object.
    #
    # @param [Object] base The object to configure.
    #
    # @return [Object] The configured base object.
    def self.extended(base)
      base.set_default_configuration
    end

    # Sets the default configuration of the object.
    #
    def set_default_configuration
    end
  end
end
