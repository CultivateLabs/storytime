require 'spec_helper'

describe Storytime::Version do

  it "creates a version when creating a Post" do
    expect(Storytime::Version.all.count).to eq(0)
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post, published_at: nil, user: user, draft_user_id: user.id, draft_content: "Testing 123")
    expect(post).to_not be_published
    expect(Storytime::Version.all.count).to eq(1)
    expect(post.latest_version).to eq(Storytime::Version.last)
    expect(post.latest_version.content).to eq("Testing 123")
    expect(post.latest_version.user).to eq(user)
  end

  it "publishes a post with latest_version content" do
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post, published_at: nil, user: user, draft_user_id: user.id, draft_content: "Testing 123")
    expect(post).to_not be_published
    expect(post.content).to_not eq("Testing 123")
    post.publish!
    expect(post).to be_published
    expect(post.content).to eq("Testing 123")
  end

  it "returns the latest version content as draft_content" do
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post, published_at: nil, user: user, draft_user_id: user.id, draft_content: "Testing 123")
    post.reload
    expect(post.draft_content).to eq(post.latest_version.content)
  end

  it "does not create a version when content does not change" do
    post = FactoryBot.create(:post, published_at: nil, draft_content: "Testing 123")
    expect(Storytime::Version.all.count).to eq(1)
    post.update(excerpt: "New Excerpt")
    expect(Storytime::Version.all.count).to eq(1)
  end

  it "creates a version when content is updated" do
    post = FactoryBot.create(:post, draft_content: "Testing 123")
    expect(Storytime::Version.all.count).to eq(1)
    post.update(draft_content: "New Content")
    expect(Storytime::Version.all.count).to eq(2)
    expect(post.content).to eq("New Content")
  end

  it "reverts to a previous version" do
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post, user: user)
    version1 = Storytime::Version.last
    post.update(draft_content: "New Content", draft_user_id: user.id)
    expect(post.content).to eq("New Content")
    post.update(draft_version_id: version1.id)
    expect(post.content).to eq(version1.content)
  end
end
