# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require "pundit/rspec"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

poltergeist_options = {
  phantomjs_logger: Logger.new('/dev/null'),
  # inspector: true,
  # debug: true,
  phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1'],
  js_errors: false
}

Capybara.register_driver :poltergeist_st do |app|
  Capybara::Poltergeist::Driver.new(app, poltergeist_options)
end

Capybara.javascript_driver = :poltergeist_st

RSpec.configure do |config|

  # config.before(:all) do
  #   if self.respond_to? :visit
  #     visit '/assets/application.css'
  #     visit '/assets/application.js'
  #   end
  # end

  config.before(:each) do
    Storytime::Role.seed
    Storytime::Action.seed
    Storytime::Permission.seed
  end

  # config.after(type: :feature) do 
  #   page.driver.reset! 
  #   Capybara.reset_sessions!
  # end

  # config.after(:suite) do
  #   Capybara.reset_sessions!
  # end
  
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include FeatureMacros, type: :feature
  config.include Storytime::Engine.routes.url_helpers
  config.include Devise::TestHelpers, type: :controller

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

def have_image(url)
  have_xpath("//img[@src='#{url}']")
end