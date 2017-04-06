require 'yaml'
require 'json'

module OodAppkit
  # Helper methods for parsing/deserializing yml configuration files
  module ConfigParser
    # Specific version hash in the yaml file to parse
    YAML_VERSION = 'v1'

    # Identifier used to distinguish class names when deserializing
    CLASS_ID = 'type'

    # Exception raise when unable to access config file or directory
    class InvalidConfigPath < StandardError; end

    # Parse/deserialize a configuration file or a set of configuration files
    # @param config [#to_s] configuration file or directory
    # @raise [InvalidConfigPath] if config path is inaccessible
    # @return [Hash] hash of deserialized config file
    def self.parse(config:)
      # use 'type' to distinguish class name in yaml file
      JSON.create_id = CLASS_ID

      config = Pathname.new(config.to_s).expand_path
      if config.file?
        parse_file config
      elsif config.directory?
        config.children.each_with_object({}) do |f, h|
          /^(.+)\.yml$/.match(f.basename.to_s) do
            hsh = parse_file(f)
            h[$1.to_sym] = hsh unless hsh.empty?
          end
        end
      else
        raise InvalidConfigPath, "invalid config path: #{config}"
      end
    end

    private
      # Parse a single yaml file
      def self.parse_file(file)
        JSON.load(JSON.dump(YAML.load(File.read(file.to_s)).fetch(YAML_VERSION, {}))).deep_symbolize_keys
      end
  end
end
