$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "storytime/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "storytime"
  s.version     = Storytime::VERSION
  s.authors     = ["Ben Roesch, David Van Der Beek"]
  s.email       = ["ben@federisgroup.com, david@federisgroup.com"]
  s.summary     = "A simple cms and blogging engine for rails apps."
  s.description = "A simple cms and blogging engine for rails apps."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.0"
  s.add_dependency "devise"
  s.add_dependency "pundit"
  s.add_dependency "kaminari"
  s.add_dependency "jbuilder"
  s.add_dependency "sass-rails", "~> 4.0.3"
  s.add_dependency "bootstrap-sass"
  s.add_dependency "coffee-rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "simple_form"
  s.add_dependency "friendly_id"
  s.add_dependency "fog"
  s.add_dependency "carrierwave"
  s.add_dependency "mini_magick"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist", "~>1.5"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "guard-rspec", "~> 4.2.8"
  s.add_development_dependency "spring-commands-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "pry-nav"
end
