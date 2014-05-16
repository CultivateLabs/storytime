require 'spec_helper'

describe Storytime::Version do

  it "creates a version when creating a Post" do
    Storytime::Version.all.count.should == 0
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, published: false, user: user, draft_user_id: user.id, draft_content: "Testing 123")
    post.published?.should be_false
    Storytime::Version.all.count.should == 1
    post.latest_version.should == Storytime::Version.last
    post.latest_version.content.should == "Testing 123"
    post.latest_version.user.should == user
  end

  it "publishes a post with latest_version content" do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, published: false, user: user, draft_user_id: user.id, draft_content: "Testing 123")
    post.published?.should be_false
    post.content.should_not == "Testing 123"
    post.publish!
    post.published?.should be_true
    post.content.should == "Testing 123"
  end

  it "returns the latest version content as draft_content" do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, published: false, user: user, draft_user_id: user.id, draft_content: "Testing 123")
    post.reload
    post.draft_content.should == post.latest_version.content
  end

  it "does not create a version when content does not change" do
    post = FactoryGirl.create(:post, published: false, draft_content: "Testing 123")
    Storytime::Version.all.count.should == 1
    post.update(excerpt: "New Excerpt")
    Storytime::Version.all.count.should == 1
  end

  it "creates a version when content is updated" do
    post = FactoryGirl.create(:post, published: true, draft_content: "Testing 123")
    Storytime::Version.all.count.should == 1
    post.update(draft_content: "New Content")
    Storytime::Version.all.count.should == 2
    post.content.should == "New Content"
  end
end