require 'spec_helper'

describe "In the dashboard, Pages" do
  before{ login }

  it "lists pages" do
    3.times{ FactoryGirl.create(:page) }
    visit dashboard_pages_path
    
    Storytime::Page.all.each do |p|
      page.should have_link(p.title, href: edit_dashboard_page_path(p))
      page.should_not have_content(p.content)
    end
  end
  
  it "creates a page" do
    Storytime::Page.count.should == 0

    visit new_dashboard_page_path
    fill_in "page_title", with: "The Story"
    fill_in "page_draft_content", with: "It was a dark and stormy night..."
    click_button "Create Page"
    
    page.should have_content(I18n.t('flash.pages.create.success'))
    Storytime::Page.count.should == 1

    pg = Storytime::Page.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == current_user
    pg.should_not be_published
  end

  it "updates a page" do
    pg = FactoryGirl.create(:page, published: false)
    original_creator = pg.user
    Storytime::Page.count.should == 1

    visit edit_dashboard_page_path(pg)
    fill_in "page_title", with: "The Story"
    fill_in "page_draft_content", with: "It was a dark and stormy night..."
    click_button "Update Page"
    
    page.should have_content(I18n.t('flash.pages.update.success'))
    Storytime::Page.count.should == 1

    pg = Storytime::Page.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == original_creator
    pg.should_not be_published
  end

  it "deletes a page", js: true do
    3.times{|i| FactoryGirl.create(:page) }
    visit dashboard_pages_path
    p1 = Storytime::Page.first
    p2 = Storytime::Page.last
    click_link("delete_page_#{p1.id}")

    page.should_not have_content(p1.title)
    page.should have_content(p2.title)

    expect{ p1.reload }.to raise_error
  end
  
end
