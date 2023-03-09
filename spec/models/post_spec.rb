require 'spec_helper'

describe Storytime::Post do

  describe "#to_partial_path" do
    before{ Storytime::BlogPost.instance_variable_set "@_to_partial_path", nil }
    after{ Storytime::BlogPost.instance_variable_set "@_to_partial_path", nil }

    it "includes site in the path" do
      allow(File).to receive(:exist?).and_return(true)

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
    expect(post.slug).to eq(post.title.parameterize)
  end

  it "sets slug to user inputted value" do
    post = FactoryGirl.create(:post)

    post.slug = "random slug here"
    post.save

    expect(post.slug).to eq("random-slug-here")
  end

  it "does not allow the same slug" do
    post_1 = FactoryGirl.create(:post)
    post_2 = FactoryGirl.create(:post)

    post_2.slug = post_1.slug
    post_2.save

    expect(post_2.slug).to_not eq(post_1.slug)
    expect(post_2.slug).to include(post_1.slug)
  end

  it "does not allow a blank slug" do
    post = FactoryGirl.create(:post)
    post.slug = ""
    post.save

    expect(post.slug).to_not eq("")
    expect(post.slug).to eq(post.title.parameterize)
  end

  it "creates tags from tag_list attribute" do
    post = FactoryGirl.create(:post)
    post.tag_list = ["tag1", "tag2"]
    expect(post.tags.count).to eq(2)
  end

  it "scopes posts by tag" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    post_2 = FactoryGirl.create(:post, tag_list: ["tag1"])

    expect(Storytime::Post.tagged_with("tag1")).to include(post_1)
    expect(Storytime::Post.tagged_with("tag1")).to include(post_2)
    expect(Storytime::Post.tagged_with("tag2")).to include(post_1)
    expect(Storytime::Post.tagged_with("tag2")).to_not include(post_2)
  end

  it "counts tags across posts" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    post_2 = FactoryGirl.create(:post, tag_list: ["tag1"])

    expect(Storytime::Post.tag_counts.find_by(name: "tag1").count).to eq(2)
    expect(Storytime::Post.tag_counts.find_by(name: "tag2").count).to eq(1)
  end
end
