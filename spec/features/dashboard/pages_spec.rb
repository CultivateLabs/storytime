require 'spec_helper'

describe "In the dashboard, Pages" do
  before do 
    login_admin
  end

  it "lists pages" do
    post = FactoryGirl.create(:post)
    3.times{ FactoryGirl.create(:page) }
    visit url_for([:dashboard, Storytime::Post, type: Storytime::Page.type_name])
    
    Storytime::Page.all.each do |p|
      page.should have_link(p.title, href: url_for([:edit, :dashboard, p, only_path: true]))
      page.should_not have_content(p.content)
    end

    page.should_not have_link(post.title, href: url_for([:edit, :dashboard, post, only_path: true]))
  end
  
  it "creates a page" do
    Storytime::Page.count.should == 0
    media = FactoryGirl.create(:media)

    visit url_for([:new, :dashboard, :post, type: Storytime::Page.type_name, only_path: true])
    fill_in "post_title", with: "The Story"
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    find("#featured_media_id").set media.id
    
    click_button "Create Page"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::Page.count.should == 1

    pg = Storytime::Page.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == current_user
    pg.should_not be_published
    pg.type.should == "Storytime::Page"
    pg.featured_media.should == media
  end

  it "updates a page" do
    pg = FactoryGirl.create(:page, published_at: nil)
    original_creator = pg.user
    Storytime::Page.count.should == 1
    
    visit url_for([:edit, :dashboard, pg])
    fill_in "post_title", with: "The Story"
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    click_button "Update Page"
    
    page.should have_content(I18n.t('flash.posts.update.success'))
    Storytime::Page.count.should == 1

    pg = Storytime::Page.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == original_creator
    pg.should_not be_published
    pg.type.should == "Storytime::Page"
  end

  it "deletes a page", js: true do
    3.times{|i| FactoryGirl.create(:page) }
    visit url_for([:dashboard, Storytime::Post, type: Storytime::Page.type_name, only_path: true])
    p1 = Storytime::Page.first
    p2 = Storytime::Page.last
    click_link("delete_page_#{p1.id}")

    page.should_not have_content(p1.title)
    page.should have_content(p2.title)

    expect{ p1.reload }.to raise_error
  end
  
end
