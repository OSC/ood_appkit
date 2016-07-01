require 'addressable'

require 'ood_appkit/version'
require 'ood_appkit/configuration'
require 'ood_appkit/public_url'
require 'ood_appkit/dashboard_url'
require 'ood_appkit/shell_url'
require 'ood_appkit/files_url'
require 'ood_appkit/editor_url'
require 'ood_appkit/files_rack_app'
require 'ood_appkit/markdown_template_handler'
require 'ood_appkit/log_formatter'
require 'ood_appkit/cluster'
require 'ood_appkit/server'

# The main namespace for OodAppkit. Provides a global configuration.
module OodAppkit
  extend Configuration
  require 'ood_appkit/engine' if defined?(Rails)

  # A namespace to hold all subclasses of {Server}
  module Servers
    require 'ood_appkit/servers/torque'
    require 'ood_appkit/servers/moab'
    require 'ood_appkit/servers/ganglia'
  end

  # A namespace for validators used to validate a cluster
  module Validators
    require 'ood_appkit/validators/groups'
  end
end
