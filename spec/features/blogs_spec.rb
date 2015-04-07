require 'spec_helper'

describe "Blogs" do
  before do
    setup_site(FactoryGirl.create(:admin))
  end
  
  it "lists posts belonging to that blog" do
    3.times{ FactoryGirl.create(:post, blog: @current_site.blogs.first, site: @current_site) }
    other_blog_post = FactoryGirl.create(:post, site: @current_site)
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

      expect(page).not_to have_content(other_blog_post.title)
      expect(page).not_to have_content(other_blog_post.excerpt)
    end
  end
end
