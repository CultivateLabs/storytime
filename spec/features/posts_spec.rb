require 'spec_helper'

describe "Posts" do
  before do
    setup_site
  end
  
  it "lists posts" do
    3.times{ FactoryGirl.create(:post) }
    static_page = FactoryGirl.create(:page)
    visit url_for([Storytime::BlogPost, only_path: true])

    within ".post-list" do
      Storytime::Post.primary_feed.each do |p|
        page.should have_content(p.title)
        page.should have_content(p.excerpt)
        page.should_not have_content(p.content)
      end

      expect(page).not_to have_content(static_page.title)
      expect(page).not_to have_content(static_page.excerpt)
    end
  end

  it "shows a post" do
    post = FactoryGirl.create(:post)
    visit url_for([post, only_path: true])

    expect(page).to have_content(post.title)
    expect(page).to have_content(post.content)
  end
  
end
