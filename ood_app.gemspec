$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ood_app/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ood_app"
  s.version     = OodApp::VERSION
  s.authors     = ["Eric Franz"]
  s.email       = ["efranz@osc.edu"]
  s.homepage    = "https://github.com/osc"
  s.summary     = "Interface with other apps and deploy your app using this gem."
  s.description = "Interface with other apps and deploy your app using this gem."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "addressable", "~> 2.4"
  s.add_dependency "redcarpet", "~> 3.2"

  s.add_development_dependency "sqlite3"
end
