require 'ostruct'

module OodApp
  # Sets up the OodRails Engine
  #
  #   Sets up the parent engine
  #   Sets the dataroot to ENV['RAILS_DATAROOT']
  #   Throws an exception if the data root is not defined
  #   Makes any helpers available to all views
  class Engine < Rails::Engine
    initializer 'Set up default parent engine' do |app|
      OodApp.parent_engine ||= Rails.application
    end

    config.before_initialize do
      # RAILS_DATAROOT for legacy deployments
      OodApp.dataroot = Pathname.new(ENV['RAILS_DATAROOT']) if ENV['RAILS_DATAROOT']
      # OOD_DATAROOT for updated deployments takes precedence

      OodApp.dataroot = Pathname.new(ENV['OOD_DATAROOT']) if ENV['OOD_DATAROOT']


      # initialize dashboard, files, and shell objects
      OodApp.dashboard = OpenStruct.new(
        url: ENV['OOD_DASHBOARD_URL'] || '/pun/sys/dashboard',
        title: ENV['OOD_DASHBOARD_TITLE'] || 'OSC OnDemand',
      )
      OodApp.shell = ::OodApp::ShellApp.new(ENV['OOD_SHELL_URL'] || OodApp::ShellApp.default_base_url)
      OodApp.files = ::OodApp::FilesApp.new(ENV['OOD_FILES_URL'] || OodApp::FilesApp.default_base_url)
    end

    # Exception Class thrown when the <tt>OOD_DATAROOT</tt> environment variable is not defined.
    class DatarootEnvMissing < StandardError; end
    config.after_initialize do
      raise DatarootEnvMissing, "OodApp.dataroot must be defined (default: ENV['OOD_DATAROOT'])" unless OodApp.dataroot
    end

    config.to_prepare do
      # TODO:
      # make the helper available to all views
      # i.e. ApplicationController.helper(OodBannerHelper)
    end
  end
end
