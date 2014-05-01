require 'spec_helper'

describe "As a user, Posts" do
  before{ login }
  
  it "creates a post" do
    Storytime::Post.count.should == 0

    visit new_post_path
    fill_in "post_content", with: "It was a dark and stormy night..."
    click_button "Create Post"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::Post.count.should == 1
    Storytime::Post.last.content.should == "It was a dark and stormy night..."
    Storytime::Post.last.user.should == current_user
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
