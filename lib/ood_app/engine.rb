module OodApp
  # The Rails Engine that defines the OodApp environment
  class Engine < Rails::Engine
    # Set default configuration options before initializers are called
    config.before_initialize do
      OodApp.set_default_configuration
    end

    # Confirm the `OodApp.dataroot` configuration option was set
    config.after_initialize do
      raise UndefinedDataroot, "OodApp.dataroot must be defined (default: ENV['OOD_DATAROOT'])" unless OodApp.dataroot
    end

    config.to_prepare do
      # TODO:
      # make the helper available to all views
      # i.e. ApplicationController.helper(OodBannerHelper)
    end

    # An exception raised when `OodApp.dataroot` configuration option is undefined
    class UndefinedDataroot < StandardError; end
  end
end
