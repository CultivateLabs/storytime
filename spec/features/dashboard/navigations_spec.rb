require 'spec_helper'

describe "In the dashboard, Navigations" do

  before{ login_admin }
  
  it "renders the navigations index" do
    visit dashboard_navigations_path
    expect(page).to have_content I18n.t('dashboard.navigations.index.header')
  end
end
