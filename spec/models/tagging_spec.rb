require 'spec_helper'

describe Storytime::Tagging do
  it "unused tags remain after deleting a post" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    post_2 = FactoryGirl.create(:post, tag_list: ["tag1"])
    Storytime::Tag.all.count.should == 2
    post_1.destroy
    Storytime::Tag.all.count.should == 2
    post_2.destroy
    Storytime::Tag.all.count.should == 2
  end

  it "does not remove unused tags after updating tag list" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    Storytime::Tag.all.count.should == 2
    post_1.update(tag_list: ["tag1"])
    Storytime::Tag.all.count.should == 2
    post_1.tags.count.should == 1
  end

  it "does not removes tags used by other posts after updating tag list" do
    post_1 = FactoryGirl.create(:post, tag_list: ["tag1", "tag2"])
    post_2 = FactoryGirl.create(:post, tag_list: ["tag2"])
    Storytime::Tag.all.count.should == 2
    post_1.update(tag_list: ["tag1"])
    Storytime::Tag.all.count.should == 2
  end
end