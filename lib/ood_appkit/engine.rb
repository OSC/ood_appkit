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

      OodAppkit.setup_ood_log_formatting if OodAppkit.use_ood_log_formatting && ::Rails.env.production?
    end

    # An exception raised when `OodAppkit.dataroot` configuration option is undefined
    class UndefinedDataroot < StandardError; end
  end
end
