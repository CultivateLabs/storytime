$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "storytime/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "storytime"
  s.version     = Storytime::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Storytime."
  s.description = "TODO: Description of Storytime."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.0"
  s.add_dependency "devise"
  s.add_dependency "pundit"
  s.add_dependency "kaminari"
  s.add_dependency "sass-rails", "~> 4.0.3"
  s.add_dependency "bootstrap-sass"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "guard-rspec", "~> 4.2.8"
  s.add_development_dependency "spring-commands-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "pry-nav"
end
