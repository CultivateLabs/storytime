DEFAULT_HOST = "lvh.me"

RSpec.configure do |config|
  Capybara.default_host = "http://#{DEFAULT_HOST}"
  Capybara.app_host = "http://#{DEFAULT_HOST}"
  Capybara.always_include_port = true
  Capybara.javascript_driver = :poltergeist
end