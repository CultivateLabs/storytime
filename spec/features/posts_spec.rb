require 'spec_helper'

describe "Posts" do
  before do
    setup_site
  end
  
  it "lists posts" do
    3.times{ FactoryGirl.create(:post) }
    visit posts_path

    Storytime::Post.all.each do |p|
      page.should have_content(p.title)
      page.should have_content(p.excerpt)
      page.should_not have_content(p.content)
    end
  end

  it "shows a post" do
    post = FactoryGirl.create(:post)
    visit post_path(post)

    page.should have_content(post.title)
    page.should have_content(post.content)
  end
  
end
