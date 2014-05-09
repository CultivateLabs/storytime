require 'spec_helper'

describe "Pages" do

  it "shows a page" do
    page = FactoryGirl.create(:page)
    visit page_path(page)

    page.should have_content(page.title)
    page.should have_content(page.content)
  end
  
end