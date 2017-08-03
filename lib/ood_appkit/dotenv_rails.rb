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

# NOTE: we explicitly omit because this block ends up requiring spring files in
# production when building apps as root because spring calls expand_path on $HOME
# or ~ which depends on $HOME being set, resulting in a crash
#
# We can uncomment this if we use Bundler library to check the groups spring has been
# explicitly specified to load in (i.e. test, dev envs)
#
# # Watch all loaded env files with Spring
# begin
#   require "spring/commands"
#   ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
#     event = ActiveSupport::Notifications::Event.new(*args)
#     Spring.watch event.payload[:env].filename if Rails.application
#   end
# rescue LoadError
#   # Spring is not available
# end


module OodAppkit
  class DotenvRails
    attr_reader :root, :shared_dir, :etc_dir

    def initialize(root_dir: nil, etc_dir: nil, shared_dir: Pathname.new("/etc/ood/config/shared"))
      @root = root_dir.nil? ? default_root : Pathname.new(root_dir)
      @shared_dir = shared_dir
      @etc_dir = etc_dir || default_etc_dir
    end

    def default_etc_dir
      Pathname.new("/etc/ood/config/apps/#{root.basename}")
    end

    def default_root
      Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
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

