require 'spec_helper'

describe "In the dashboard, Pages" do
  before do 
    login_admin
  end

  it "lists draft pages" do
    post = FactoryGirl.create(:post)
    3.times{ FactoryGirl.create(:page) }
    3.times{ FactoryGirl.create(:page, published_at: nil) }
    visit url_for([:dashboard, Storytime::Post, type: Storytime::Page.type_name])
    
    Storytime::Page.all.each do |p|
      expect(page).to have_link(p.title, href: url_for([:edit, :dashboard, p, only_path: true])) if p.published_at.nil?
      expect(page).not_to have_link(p.title, href: url_for([:edit, :dashboard, p, only_path: true])) if p.published_at.present?
      page.should_not have_content(p.content)
    end

    page.should_not have_link(post.title, href: url_for([:edit, :dashboard, post, only_path: true]))
  end

  it "lists published pages" do
    post = FactoryGirl.create(:post)
    3.times{ FactoryGirl.create(:page) }
    3.times{ FactoryGirl.create(:page, published_at: nil) }
    visit url_for([:dashboard, Storytime::Post, type: Storytime::Page.type_name, published: true])
    
    Storytime::Page.all.each do |p|
      expect(page).to have_link(p.title, href: url_for([:edit, :dashboard, p, only_path: true])) if p.published_at.present?
      expect(page).not_to have_link(p.title, href: url_for([:edit, :dashboard, p, only_path: true])) if p.published_at.nil?
      page.should_not have_content(p.content)
    end

    page.should_not have_link(post.title, href: url_for([:edit, :dashboard, post, only_path: true]))
  end
  
  it "creates a page", js: true do
    Storytime::Page.count.should == 0
    media = FactoryGirl.create(:media)

    visit url_for([:new, :dashboard, :post, type: Storytime::Page.type_name, only_path: true])

    find('#post-title-input').set("The Story")
    click_link "Publish"
    fill_in "post_excerpt", with: "It was a dark and stormy night..."
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    
    click_button "Save Draft"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::Page.count.should == 1

    pg = Storytime::Page.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == current_user
    pg.should_not be_published
    pg.type.should == "Storytime::Page"
  end

  it "updates a page", js: true do
    pg = FactoryGirl.create(:page, published_at: nil)
    original_creator = pg.user
    Storytime::Page.count.should == 1
    
    visit url_for([:edit, :dashboard, pg, only_path: true])
    find('#post-title-input').set("The Story")
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    click_link "advanced-settings-panel-toggle"
    click_button "Save Draft"
    
    # page.should have_content(I18n.t('flash.posts.update.success'))
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
    expect(Storytime::Page.count).to eq(3)

    storytime_page = Storytime::Page.first
    visit url_for([:edit, :dashboard, storytime_page, type: Storytime::Page.type_name, only_path: true])
    
    click_button "post-utilities"
    click_link "Delete"

    expect { storytime_page.reload }.to raise_error

    expect(page).to_not have_content(storytime_page.title)
    expect(Storytime::Page.count).to eq(2)
  end
  
end
