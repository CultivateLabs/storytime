require 'spec_helper'

describe "In the dashboard, Pages" do
  before do 
    login_admin
  end

  it "lists pages" do
    post = FactoryGirl.create(:post)
    3.times{ FactoryGirl.create(:page) }
    visit dashboard_posts_path(post_type: "page")
    
    Storytime::Post.page_posts.each do |p|
      page.should have_link(p.title, href: edit_dashboard_post_url(p))
      page.should_not have_content(p.content)
    end

    page.should_not have_link(post.title, href: edit_dashboard_post_url(post))
  end
  
  it "creates a page" do
    Storytime::Post.page_posts.count.should == 0
    media = FactoryGirl.create(:media)

    visit new_dashboard_post_path(post_type: "page")
    fill_in "post_title", with: "The Story"
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    find("#featured_media_id").set media.id
    
    click_button "Create Page"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::Post.page_posts.count.should == 1

    pg = Storytime::Post.page_posts.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == current_user
    pg.should_not be_published
    pg.class.should == Storytime::Page
    pg.featured_media.should == media
  end

  it "updates a page" do
    pg = FactoryGirl.create(:page, published_at: nil)
    original_creator = pg.user
    Storytime::Post.page_posts.count.should == 1

    visit edit_dashboard_post_path(pg)
    fill_in "post_title", with: "The Story"
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    click_button "Update Page"
    
    page.should have_content(I18n.t('flash.posts.update.success'))
    Storytime::Post.page_posts.count.should == 1

    pg = Storytime::Post.page_posts.last
    pg.title.should == "The Story"
    pg.draft_content.should == "It was a dark and stormy night..."
    pg.user.should == original_creator
    pg.should_not be_published
  end

  it "deletes a page", js: true do
    3.times{|i| FactoryGirl.create(:page) }
    visit dashboard_posts_path(post_type: "page")
    p1 = Storytime::Post.page_posts.first
    p2 = Storytime::Post.page_posts.last
    click_link("delete_post_#{p1.id}")

    page.should_not have_content(p1.title)
    page.should have_content(p2.title)

    expect{ p1.reload }.to raise_error
  end
  
end
