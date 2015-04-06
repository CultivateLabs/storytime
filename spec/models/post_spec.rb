require 'spec_helper'

describe Storytime::Post do
  it "includes site in partial path" do
    site = FactoryGirl.create(:site, title: "Test Site")
    blog_post = FactoryGirl.create(:post, site: site)
    expect(blog_post.to_partial_path).to eq("storytime/test-site/blog_posts/blog_post")
  end

  it "sets the page slug on create" do
    post = FactoryGirl.create(:post)
    post.slug.should == post.title.parameterize
  end

  it "sets slug to user inputted value" do
    post = FactoryGirl.create(:post)

    post.slug = "random slug here"
    post.save

    post.slug.should == "random-slug-here"
  end

  it "does not allow the same slug" do
    post_1 = FactoryGirl.create(:post)
    post_2 = FactoryGirl.create(:post)

    post_2.slug = post_1.slug
    post_2.save

    post_2.slug.should_not == post_1.slug
    post_2.slug.should include(post_1.slug)
  end

  it "does not allow a blank slug" do
    post = FactoryGirl.create(:post)
    post.slug = ""
    post.save

    post.slug.should_not == ""
    post.slug.should == post.title.parameterize
  end

  it "creates tags from tag_list attribute" do
    post = FactoryGirl.create(:post)
    post.tag_list = ["tag1", "tag2"]
    post.tags.count.should == 2
  end

  it "scopes posts by tag" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    post_2 = FactoryGirl.create(:post, tag_list: ["tag1"])

    Storytime::Post.tagged_with("tag1").should include(post_1)
    Storytime::Post.tagged_with("tag1").should include(post_2)
    Storytime::Post.tagged_with("tag2").should include(post_1)
    Storytime::Post.tagged_with("tag2").should_not include(post_2)
  end

  it "counts tags across posts" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    post_2 = FactoryGirl.create(:post, tag_list: ["tag1"])

    Storytime::Post.tag_counts.find_by(name: "tag1").count.should == 2
    Storytime::Post.tag_counts.find_by(name: "tag2").count.should == 1
  end

  context "#primary_feed" do
    it "shows posts where post type is not excluded from the main feed" do
      post_1 = FactoryGirl.create(:post)
      post_2 = FactoryGirl.create(:post)

      post_3 = FactoryGirl.create(:page)
      post_4 = FactoryGirl.create(:page)

      feed = Storytime::Post.primary_feed
      expect(feed).to include(post_1)
      expect(feed).to include(post_2)

      expect(feed).to_not include(post_3)
      expect(feed).to_not include(post_4)
    end
  end
end