require 'spec_helper'

describe "In the dashboard, Posts" do
  before{ login }

  it "lists posts" do
    3.times{ FactoryGirl.create(:post) }
    visit dashboard_posts_path
    
    Storytime::Post.all.each do |p|
      page.should have_link(p.title, href: edit_dashboard_post_path(p))
      page.should_not have_content(p.content)
    end
  end

  
  it "creates a post" do
    Storytime::Post.count.should == 0

    visit new_dashboard_post_path
    fill_in "post_title", with: "The Story"
    fill_in "post_content", with: "It was a dark and stormy night..."
    click_button "Create Post"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::Post.count.should == 1

    post = Storytime::Post.last
    post.title.should == "The Story"
    post.content.should == "It was a dark and stormy night..."
    post.user.should == current_user
    post.should_not be_published
  end

  it "updates a post" do
    post = FactoryGirl.create(:post, published: false)
    original_creator = post.user
    Storytime::Post.count.should == 1

    visit edit_dashboard_post_path(post)
    fill_in "post_title", with: "The Story"
    fill_in "post_content", with: "It was a dark and stormy night..."
    click_button "Update Post"
    
    page.should have_content(I18n.t('flash.posts.update.success'))
    Storytime::Post.count.should == 1

    post = Storytime::Post.last
    post.title.should == "The Story"
    post.content.should == "It was a dark and stormy night..."
    post.user.should == original_creator
    post.should_not be_published
  end


  # it "deletes a announcement", js: true do
  #   3.times{|i| current_user.announcements.create(content: "announcement #{i}") }
  #   visit announcements_path
  #   a1 = Announcement.first
  #   a2 = Announcement.last
  #   click_link("delete_announcement_#{a1.id}")

  #   page.should_not have_content(a1.content)
  #   page.should have_content(a2.content)
  # end
  
end
