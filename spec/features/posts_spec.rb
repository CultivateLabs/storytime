require 'spec_helper'

describe "Posts" do
  before do
    setup_site(FactoryGirl.create(:admin))
  end

  it "shows a post" do
    post = FactoryGirl.create(:post, blog: @current_site.blogs.first, site: @current_site)
    visit url_for([post, only_path: true])

    expect(page).to have_content(post.title)
    expect(page).to have_content(post.content)
  end
end
