require "ood_app/version"
require "ood_app/configuration"

module OodApp
  extend Configuration
  require "ood_app/engine" if defined?(Rails)
end
