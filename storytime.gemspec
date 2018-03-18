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

  s.add_dependency "rails", ">= 4.0"
  s.add_dependency "pundit", ">= 0.2"
  s.add_dependency "kaminari", ">= 0.15"
  s.add_dependency "jbuilder", ">= 1.5"
  s.add_dependency "sass-rails", ">= 4.0"
  s.add_dependency "bootstrap-sass", ">= 3.1"
  s.add_dependency "coffee-rails", ">= 4.0"
  s.add_dependency "jquery-rails", ">= 3.0"
  s.add_dependency "simple_form", ">= 3.0"
  s.add_dependency "friendly_id", ">= 5.0"
  s.add_dependency "fog", ">= 1.18"
  s.add_dependency "carrierwave", ">= 1.0"
  s.add_dependency "mini_magick", ">= 3.7"
  s.add_dependency "nokogiri", ">= 1.6"
  s.add_dependency "font-awesome-sass", ">= 4.0.3"
  s.add_dependency "jquery-ui-rails", "~> 5.0"
  s.add_dependency "thor", "~> 0.19.1"
  s.add_dependency "leather", ">= 3.5"
  s.add_dependency "codemirror-rails", ">=5.0"
  s.add_dependency "storytime-admin", "~> 0.2"
  s.add_dependency "devise", ">= 3.2"
  s.add_dependency "cocoon"
  s.add_dependency "acts_as_list"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist", "~>1.5"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "guard-rspec", "~> 4.2.8"
  s.add_development_dependency "spring-commands-rspec"
  s.add_development_dependency "spring", "1.1.3"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
  s.add_development_dependency "launchy"
  s.add_development_dependency "thin"
end
