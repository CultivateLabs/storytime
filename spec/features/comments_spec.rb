require 'spec_helper'

describe "Comments" do
  before do
    setup_site
    login
  end
  
  it "lists comments on a post" do
    post = FactoryGirl.create(:post)
    3.times{ FactoryGirl.create(:comment, post: post) }
    other_post_comment = FactoryGirl.create(:comment)

    visit post_path(post)

    post.comments.each do |c|
      page.should have_content(c.content)
      page.should have_content(c.user.storytime_name)
    end

    page.should_not have_content(other_post_comment.content)
  end

  it "creates a comment" do
    post = FactoryGirl.create(:post)
    comment_count = post.comments.count

    visit post_path(post)

    fill_in "comment_content", with: "Here's some comment content"
    click_button "Create Comment"

    page.should have_content(I18n.t('flash.comments.create.success'))
    expect(post.comments.count).to eq(comment_count + 1)
    comment = post.comments.last
    expect(comment.content).to eq("Here's some comment content")
    expect(comment.user).to eq(current_user)
  end

  # it "edits a comment" do
  #   comment = FactoryGirl.create(:comment)
  #   post = comment.post
  #   comment_count = post.comments.count

  #   visit post_path(post)

  #   click_link "edit_comment_#{comment.id}"
  #   fill_in "comment_content", with: "Here's some comment content"
  #   click_button "Submit Comment"

  #   page.should have_content(I18n.t('flash.comments.create.success'))
  #   expect(post.comments.count).to eq(comment_count)
  #   comment = post.comments.last
  #   expect(comment.content).to eq("Here's some comment content")
  #   expect(comment.user).to eq(current_user)
  # end

  # it "deletes a comment" do
  #   post = FactoryGirl.create(:post)
  #   visit post_path(post)

  #   page.should have_content(post.title)
  #   page.should have_content(post.content)
  # end
  
end
