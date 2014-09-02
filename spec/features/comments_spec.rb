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

    visit url_for([post, only_path: true])

    post.comments.each do |c|
      page.should have_content(c.content)
      page.should have_content(c.user.storytime_name)
    end

    page.should_not have_content(other_post_comment.content)
  end

  it "creates a comment" do
    post = FactoryGirl.create(:post)
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
    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, post: post)
    comment_to_delete = FactoryGirl.create(:comment, post: post, user: current_user)

    visit url_for([post, only_path: true])

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to_not have_link("delete_comment_#{other_persons_comment.id}")

    expect(page).to have_content(comment_to_delete.content)
    click_link "delete_comment_#{comment_to_delete.id}"
    
    expect(page).to_not have_content(comment_to_delete.content)

    expect{ comment_to_delete.reload }.to raise_error
  end
  
end
