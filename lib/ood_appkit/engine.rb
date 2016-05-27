module OodAppkit
  # The Rails Engine that defines the OodAppkit environment
  class Engine < Rails::Engine
    # Set default configuration options before initializers are called
    config.before_initialize do
      OodAppkit.set_default_configuration
    end

    # Confirm the `OodAppkit.dataroot` configuration option was set
    config.after_initialize do
      raise UndefinedDataroot, "OodAppkit.dataroot must be defined (default: ENV['OOD_DATAROOT'])" unless OodAppkit.dataroot
    end

    config.to_prepare do
      # TODO:
      # make the helper available to all views
      # i.e. ApplicationController.helper(OodBannerHelper)
    end

    # An exception raised when `OodAppkit.dataroot` configuration option is undefined
    class UndefinedDataroot < StandardError; end
  end
end
