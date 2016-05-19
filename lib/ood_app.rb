require 'addressable'

require 'ood_app/version'
require 'ood_app/configuration'
require 'ood_app/dashboard_app'
require 'ood_app/shell_app'
require 'ood_app/files_app'

# The main namespace for OodApp. Provides a global configuration.
module OodApp
  extend Configuration
  require 'ood_app/engine' if defined?(Rails)
end