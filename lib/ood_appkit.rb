require 'addressable'

require 'ood_appkit/version'
require 'ood_appkit/configuration'
require 'ood_appkit/dashboard_url'
require 'ood_appkit/shell_url'
require 'ood_appkit/files_url'
require 'ood_appkit/files_rack_app'
require 'ood_appkit/markdown_template_handler'

# The main namespace for OodAppkit. Provides a global configuration.
module OodAppkit
  extend Configuration
  require 'ood_appkit/engine' if defined?(Rails)
end
