$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "storytime/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "storytime"
  s.version     = Storytime::VERSION
  s.authors     = ["Ben Roesch, David Van Der Beek, Brandon Robins"]
  s.email       = ["ben@flyoverworks.com, david@flyoverworks.com, brandon@flyoverworks.com"]
  s.summary     = "A simple cms and blogging engine for rails apps."
  s.description = "A simple cms and blogging engine for rails apps."
  s.license     = "MIT"

  s.files = `git ls-files -z`.split("\x0") - Dir["screenshots/*"]
  s.executables << 'storytime'
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/tmp/**/*"] - Dir["spec/dummy/log/*"] - Dir["spec/dummy/public/uploads/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 7.0"
  s.add_dependency "pundit", ">= 2.0.0"
  s.add_dependency "kaminari", ">= 1.0.0"
  s.add_dependency "jbuilder", ">= 2.0.0"
  s.add_dependency "sass-rails", ">= 4.0"
  s.add_dependency "bootstrap-sass", ">= 3.1"
  s.add_dependency "coffee-rails", ">= 4.0"
  s.add_dependency "jquery-rails", ">= 3.0"
  s.add_dependency "simple_form", ">= 3.0"
  s.add_dependency "friendly_id", ">= 5.0"
  s.add_dependency "fog-aws", ">= 3.0"
  s.add_dependency "carrierwave", ">= 1.0"
  s.add_dependency "mini_magick", ">= 3.7"
  s.add_dependency "nokogiri", ">= 1.6"
  s.add_dependency "font-awesome-sass", "<= 4.7.0"
  s.add_dependency "jquery-ui-rails", "~> 6.0"
  s.add_dependency "thor", ">= 0.19.1"
  s.add_dependency "devise", ">= 3.2"
  s.add_dependency "cocoon"
  s.add_dependency "acts_as_list"
  s.add_dependency "sprockets", "<4.0"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist", "~>1.5"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
  s.add_development_dependency "launchy"
end
