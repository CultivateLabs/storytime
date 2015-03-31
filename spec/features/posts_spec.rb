require 'spec_helper'
require 'pry'

describe "Posts" do
  before do
    setup_site(FactoryGirl.create(:admin))
  end
  
  it "lists posts" do
    3.times{ FactoryGirl.create(:post, blog: @current_site.blogs.first, site: @current_site) }
    static_page = FactoryGirl.create(:page, site: @current_site)
    visit url_for([@current_site.blogs.first, only_path: true])

    within ".post-list" do
      @current_site.blogs.first.posts.each do |p|
        page.should have_content(p.title)
        page.should have_content(p.excerpt)
        page.should_not have_content(p.content)
      end

      expect(page).not_to have_content(static_page.title)
      expect(page).not_to have_content(static_page.excerpt)
    end
  end

  it "shows a post" do
    post = FactoryGirl.create(:post, blog: @current_site.blogs.first, site: @current_site)
    visit url_for([post, only_path: true])

    expect(page).to have_content(post.title)
    expect(page).to have_content(post.content)
  end
end
