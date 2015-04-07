require 'spec_helper'

describe Storytime::Post do

  describe "#to_partial_path" do
    before{ Storytime::BlogPost.instance_variable_set "@_to_partial_path", nil }
    after{ Storytime::BlogPost.instance_variable_set "@_to_partial_path", nil }

    it "includes site in the path" do
      allow(File).to receive(:exists?).and_return(true)

      site = FactoryGirl.create(:site, title: "Test Site")
      blog_post = FactoryGirl.create(:post, site: site)
      
      partial_path = blog_post.to_partial_path
      expect(partial_path).to eq("storytime/test-site/blog_posts/blog_post")
      Storytime::BlogPost.instance_variable_set "@_to_partial_path", nil
    end

    it "looks up the inheritance chain" do
      allow(File).to receive(:exists?).and_return(false)

      site = FactoryGirl.build(:site, title: "Test Site")
      video_post = VideoPost.new(site: site)
      partial_path = video_post.to_partial_path
      expect(partial_path).to eq("storytime/posts/post")
    end
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
end