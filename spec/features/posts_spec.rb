require 'spec_helper'

describe "As a user, Posts" do
  before{ login }
  
  it "lists posts" do
    3.times{ FactoryGirl.create(:post) }
    visit posts_path
    
    Storytime::Post.all.each do |p|
      page.should have_link(p.title)
      page.should have_content(p.excerpt)
      page.should_not have_content(p.content)
    end
  end
  
end
