StorytimeAdmin.configure do |config|
  config.base_controller = "Storytime::DashboardController"
  config.ensure_admin_method = "storytime_admin?"
  config.ensure_admin_scope = "current_storytime_site"
end