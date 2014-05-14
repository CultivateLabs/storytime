require 'spec_helper'

describe Storytime::Post do
  it "creates tags from tag_list attribute" do
    post = FactoryGirl.create(:post)
    post.tag_list = "tag1, tag2"
    post.tags.count.should == 2
  end

  it "scopes posts by tag" do
    post_1 = FactoryGirl.create(:post, tag_list: "tag1, tag2")
    post_2 = FactoryGirl.create(:post, tag_list: "tag1")

    Storytime::Post.tagged_with("tag1").should include(post_1)
    Storytime::Post.tagged_with("tag1").should include(post_2)
    Storytime::Post.tagged_with("tag2").should include(post_1)
    Storytime::Post.tagged_with("tag2").should_not include(post_2)
  end

  it "counts tags across posts" do
    post_1 = FactoryGirl.create(:post, tag_list: "tag1, tag2")
    post_2 = FactoryGirl.create(:post, tag_list: "tag1")

    Storytime::Post.tag_counts.find_by(name: "tag1").count.should == 2
    Storytime::Post.tag_counts.find_by(name: "tag2").count.should == 1
  end
end