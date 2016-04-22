require "ood_app/version"
require "ood_app/configuration"
require "ood_app/shell_app"
require "ood_app/files_app"

module OodApp
  extend Configuration
  require "ood_app/engine" if defined?(Rails)
end
