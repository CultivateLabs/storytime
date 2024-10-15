require 'spec_helper'

describe "Comments", type: :feature do
  before do
    # setup_site
    login
  end

  it "lists comments on a post" do
    post = FactoryBot.create(:post, site: @current_site, blog: @current_site.blogs.first)
    3.times{ FactoryBot.create(:comment, post: post, site: @current_site) }
    other_post_comment = FactoryBot.create(:comment, site: @current_site)

    visit url_for([post, only_path: true])

    post.comments.each do |c|
      expect(page).to have_content(c.content)
      expect(page).to have_content(c.user.storytime_name)
    end

    expect(page).to_not have_content(other_post_comment.content)
  end

  it "creates a comment" do
    post = FactoryBot.create(:post, site: @current_site, blog: @current_site.blogs.first)
    comment_count = post.comments.count

    visit url_for([post, only_path: true])

    fill_in "comment_content", with: "Here's some comment content"
    click_button "Create Comment"

    expect(page).to have_content(I18n.t('flash.comments.create.success'))
    expect(post.comments.count).to eq(comment_count + 1)
    comment = post.comments.last
    expect(comment.content).to eq("Here's some comment content")
    expect(comment.user).to eq(current_user)
  end

  it "deletes a comment", js: true do
    post = FactoryBot.create(:post, site: @current_site, blog: @current_site.blogs.first)
    other_persons_comment = FactoryBot.create(:comment, post: post, site: @current_site)
    comment_to_delete = FactoryBot.create(:comment, post: post, user: current_user, site: @current_site)

    visit url_for([post, only_path: true])

    expect(page).to have_content(other_persons_comment.content)

    expect(page).to have_content(comment_to_delete.content)
    click_link "delete_comment_#{comment_to_delete.id}"

    expect(page).to_not have_content(comment_to_delete.content)

    expect{ comment_to_delete.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

end
