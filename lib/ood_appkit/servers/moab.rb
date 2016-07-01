module OodAppkit
  module Servers
    # This defines a Moab server / client software installation
    class Moab < Server
      # The path to the installation location for this software
      # @return [Pathname] the path to software installation location
      attr_reader :prefix

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # The required Moab environment variable
      # @return [Pathname] require moab env var
      attr_reader :moabhomedir

      # @param prefix [String] installation path of client software
      # @param version [String] version of client software
      # @param moabhomedir [String] required moab env var
      def initialize(prefix:, version:, moabhomedir:, **kwargs)
        super(kwargs)

        # installation path
        @prefix = Pathname.new prefix
        raise ArgumentError, "prefix path doesn't exist (#{@prefix})" unless @prefix.exist?
        raise ArgumentError, "prefix not valid directory (#{@prefix})" unless @prefix.directory?

        # version number
        @version = version

        # required moab env var
        @moabhomedir = Pathname.new moabhomedir
        raise ArgumentError, "moabhomedir path doesn't exist (#{@moabhomedir})" unless @moabhomedir.exist?
        raise ArgumentError, "moabhomedir not valid directory (#{@moabhomedir})" unless @moabhomedir.directory?
      end

      # The path to Torque software library
      # @example Locally installed Torque v5.1.1
      #   "my_software.lib" #=> "/usr/local/torque/5.1.1/lib"
      # @return [Pathname] path to libraries
      def lib
        prefix.join('lib')
      end

      # The path to Torque software binaries
      # @example Locally installed Torque v5.1.1
      #   "my_software.lib" #=> "/usr/local/torque/5.1.1/bin"
      # @return [Pathname] path to binaries
      def bin
        prefix.join('bin')
      end
    end
  end
end
