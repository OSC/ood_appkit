require "dotenv"

# COPIED FROM https://raw.githubusercontent.com/bkeepers/dotenv/a47020f6c414e0a577680b324e61876a690d2200/lib/dotenv/rails.rb
# Fix for rspec rake tasks loading in development
#
# Dotenv loads environment variables when the Rails application is initialized.
# When running `rake`, the Rails application is initialized in development.
# Rails includes some hacks to set `RAILS_ENV=test` when running `rake test`,
# but rspec does not include the same hacks.
#
# See https://github.com/bkeepers/dotenv/issues/219
if defined?(Rake.application)
  is_running_specs = Rake.application.top_level_tasks.grep(/^spec(:|$)/).any?
  Rails.env = ENV["RAILS_ENV"] ||= "test" if is_running_specs
end

Dotenv.instrumenter = ActiveSupport::Notifications
# END COPIED FROM

# WARNING: this block ends up requiring spring files that calls expand_path on $HOME
# which will crash if run when user is root.
# This block also requires spring regardless of whether the spring gem is grouped
# for "test" in the Gemfile. So now we just limit this to "test".
if Rails.env.test?
  # Watch all loaded env files with Spring
  begin
    require "spring/commands"
    ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Spring.watch event.payload[:env].filename if Rails.application
    end
  rescue LoadError
    # Spring is not available
  end
end


module OodAppkit
  class DotenvRails
    attr_reader :root

    def initialize(root_dir: nil)
      @root = root_dir.nil? ? default_root : Pathname.new(root_dir)
    end

    def default_root
      Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    def ood_config
      Pathname.new(ENV['OOD_CONFIG'] || '/etc/ood/config')
    end

    def shared_dir
      ood_config.join("shared")
    end

    def etc_dir
      ood_config.join("apps", root.basename)
    end

    def load
      ::Dotenv.load(*dotenv_files)
    end

    def dotenv_files
      [
        root.join(".env.#{Rails.env}.local"),
        (root.join(".env.local") unless Rails.env.test?),
        # (Pathname.new("/users/PZS0562/efranz/awesim/config/dashboard/.env") unless Rails.env.test?),
        # (Pathname.new("/users/PZS0562/efranz/awesim/config/shared/.env") unless Rails.env.test?),
        root.join(".env.#{Rails.env}"),
        root.join(".env")
      ].compact
    end
  end
end

