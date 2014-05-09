require 'spec_helper'

describe "Pages" do

  it "shows a page" do
    pg = FactoryGirl.create(:page)
    visit page_path(pg)
    page.should have_content(pg.title)
    page.should have_content(pg.content)
  end
  
end