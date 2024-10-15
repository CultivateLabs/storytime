require 'spec_helper'

describe "Blogs", type: :feature do
  before do
    setup_site(FactoryBot.create(:admin))
  end

  it "lists posts belonging to that blog" do
    3.times{ FactoryBot.create(:post, blog: @current_site.blogs.first, site: @current_site) }
    other_blog_post = FactoryBot.create(:post, site: @current_site)
    static_page = FactoryBot.create(:page, site: @current_site)
    visit url_for([@current_site.blogs.first, only_path: true])

    within ".post-list" do
      @current_site.blogs.first.posts.each do |p|
        expect(page).to have_content(p.title)
        expect(page).to have_content(p.excerpt)
        expect(page).to_not have_content(p.content)
      end

      expect(page).not_to have_content(static_page.title)
      expect(page).not_to have_content(static_page.excerpt)

      expect(page).not_to have_content(other_blog_post.title)
      expect(page).not_to have_content(other_blog_post.excerpt)
    end
  end
end
