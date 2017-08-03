# set environment when loading Gemfile, by adding to Gemfile:
#
# gem "ood_appkit", require: "ood_appkit/dotenv-rails-now"
#
# This ensures that the proper environment is loaded during rake tasks or
# application load, and when loading other gemfiles including ood_appkit.
#
# Copied and modified from
# https://github.com/bkeepers/dotenv/blob/a47020f6c414e0a577680b324e61876a690d2200/lib/dotenv/rails-now.rb
require "dotenv/rails"

unless Rails.env.test?
  Dotenv::Railtie.instance.root.tap do |r|
    # load .env.local first
    Dotenv.load(r.join("env.#{Rails.env}.local"), r.join(".env.local"))

    # then load /etc configs
    config = Pathname.new(ENV['OOD_CONFIG'] || '/etc/ood/config')
    Dotenv.load(config.join("apps", r.basename, "env"), config.join("shared", "env"))
  end
end

Dotenv::Railtie.load

require "ood_appkit"
