require 'redcarpet'

module OodApp
  # An object that stores and adds configuration options.
  module Configuration
    # Location where app data is stored on local filesystem
    # @return [Pathname, nil] path to app data
    def dataroot
      Pathname.new(@dataroot) if @dataroot
    end
    attr_writer :dataroot

    # System dashboard app url handler
    # @return [DashboardApp] the url handler for the system dashboard app
    attr_accessor :dashboard

    # System shell app url handler
    # @return [ShellApp] the url handler for the system shell app
    attr_accessor :shell

    # System files app url handler
    # @return [FilesApp] the url handler for the system files app
    attr_accessor :files

    # Rack middleware app that serves files on local filesystem
    # @return [FilesRackApp] the rack middleware app used to serve files
    attr_accessor :files_rack_app

    # A markdown renderer used when rendering `*.md` or `*.markdown` views
    # @return [Redcarpet::Markdown] the markdown renderer used
    attr_accessor :markdown

    # Customize configuration for this object.
    # @yield [self]
    def configure
      yield self
    end

    # Sets the default configuration for this object.
    # @return [void]
    def set_default_configuration
      ActiveSupport::Deprecation.warn("The environment variable RAILS_DATAROOT will be deprecated in an upcoming release, please use OOD_DATAROOT instead.") if ENV['RAILS_DATAROOT']
      self.dataroot = ENV['OOD_DATAROOT'] || ENV['RAILS_DATAROOT']

      # Initialize system apps
      self.dashboard = DashboardApp.new(base_url: ENV['OOD_DASHBOARD_URL'] || '/pun/sys/dashboard')
      self.shell     = ShellApp.new(base_url: ENV['OOD_SHELL_URL'] || '/pun/sys/shell')
      self.files     = FilesApp.new(base_url: ENV['OOD_FILES_URL'] || '/pun/sys/files')

      # Initialize Rack middleware app
      self.files_rack_app = FilesRackApp.new

      # Add markdown template support
      self.markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        autolink: true,
        tables: true,
        strikethrough: true,
        fenced_code_blocks: true,
        no_intra_emphasis: true
      )
    end
  end
end
