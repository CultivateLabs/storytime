require 'spec_helper'

describe "Pages" do
  before do
    setup_site
  end

  it "shows a page" do
    pg = FactoryGirl.create(:page)
    visit url_for([pg, only_path: true])
    page.should have_content(pg.content)
  end
  
end