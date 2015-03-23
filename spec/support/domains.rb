RSpec.configure do |config|
  Capybara.always_include_port = true

  config.before(type: :feature) do
    @current_site ||= FactoryGirl.build(:site)
    set_domain @current_site.custom_domain
  end

  config.before(type: :controller) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_site ||= FactoryGirl.create(:site)
    @request.host = @current_site.custom_domain
  end
end

def set_domain(domain)
  default_url_options[:host] = Capybara.app_host = "http://#{domain}"
end