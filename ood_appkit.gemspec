$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ood_appkit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ood_appkit"
  s.version     = OodAppkit::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors     = ["Eric Franz"]
  s.email       = ["efranz@osc.edu"]
  s.summary     = "Open OnDemand gem to help build OOD apps and interface with other OOD apps."
  s.description = "Provides an interface to working with other Open OnDemand (OOD) apps. It provides a dataroot for OOD apps to write data to and common assets and helper objects for providing branding and documentation within the apps."
  s.homepage    = "https://github.com/OSC/ood_appkit"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "addressable", "~> 2.4"
  s.add_dependency "redcarpet", "~> 3.2"

  s.add_development_dependency "sqlite3"
end