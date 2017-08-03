# set environment when loading Gemfile, by adding to Gemfile:
#
# gem "ood_appkit", require: "ood_appkit/dotenv-rails-now"
#
# This ensures that the proper environment is loaded during rake tasks or
# application load, and when loading other gemfiles including ood_appkit.
#
# Copied and modified from
# https://github.com/bkeepers/dotenv/blob/a47020f6c414e0a577680b324e61876a690d2200/lib/dotenv/rails-now.rb
#
require "ood_appkit/dotenv_rails"

OodAppkit::DotenvRails.new(include_local_files: ! Rails.env.test?).load

require "ood_appkit"
