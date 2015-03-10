require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :deletion
  end

  # config.before(:each, :js => true) do
  #   DatabaseCleaner.strategy = :deletion
  # end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    # Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
