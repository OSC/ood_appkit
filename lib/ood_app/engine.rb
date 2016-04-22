require 'ostruct'

module OodApp
  class Engine < ::Rails::Engine


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
      # (for now, KISS)
      #

#       # FIXME The AwesimRails.dashboard_url is hardcoded. This should probably be set by an environment variable
#       AwesimRails.dashboard_url = 'https://apps.awesim.org/devapps/'

#       # FIXME: soon determine a solution for changing the BRAND of the app
#       # we should probably pass BRAND and DASHBOARD_URL as environment variables into the PUN
#       if Rails.root.to_s =~ %r(/nfs/.*)
#         AwesimRails.ood_dashboard_url = '/pun/shared/efranz/dashboard'
#       else
#         AwesimRails.ood_dashboard_url = '/pun/sys/dashboard'
#       end
#       AwesimRails.ood_dashboard_title = 'OSC OnDemand'

#       ActionView::Template.register_template_handler :md, MarkdownTemplateHandler
#       ActionView::Template.register_template_handler :markdown, MarkdownTemplateHandler
    end

    # Exception Class thrown when the <tt>OOD_DATAROOT</tt> environment variable is not defined.
    class DatarootEnvMissing < StandardError; end
    config.after_initialize do
      raise DatarootEnvMissing, "OodApp.dataroot must be defined (default: ENV['OOD_DATAROOT'])" unless OodApp.dataroot
    end

    config.to_prepare do
      # make the helper available to all views
      # ApplicationController.helper(AwesimBannerHelper)
    end
  end
end
