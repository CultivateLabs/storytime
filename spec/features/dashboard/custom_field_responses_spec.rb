require 'spec_helper'

describe "In the dashboard, CustomFieldResponses" do
  before{ login_admin }
  
  it "creates a post with custom field responses" do
    expect(Storytime::Post.count).to eq(0)

    post_type = FactoryGirl.create(:post_type)
    custom_field = FactoryGirl.create(:custom_field, post_type: post_type)
    
    visit new_dashboard_post_path(post_type: post_type.name)
    fill_in "post_title", with: "The Story"
    fill_in "post_excerpt", with: "It was a dark and stormy night..."
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    fill_in custom_field.name.camelize, with: "custom field response value"
    click_button "Create #{post_type.name.humanize}"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::Post.count.should == 1

    post = Storytime::Post.last
    expect(post.title).to eq("The Story")
    expect(post.draft_content).to eq("It was a dark and stormy night...")
    expect(post.user).to eq(current_user)
    expect(post).to_not be_published
    expect(post.post_type).to eq(post_type)
  end

  it "updates a post with custom field responses" do
    post_type = FactoryGirl.create(:post_type)
    custom_field = FactoryGirl.create(:custom_field, post_type: post_type)
    post = FactoryGirl.create(:post, published_at: nil, post_type: post_type)
    
    expect(Storytime::Post.count).to eq(1)
    
    visit edit_dashboard_post_path(post)
    fill_in custom_field.name.camelize, with: "custom field response value"
    click_button "Update #{post_type.name.humanize}"
    
    expect(page).to have_content(I18n.t('flash.posts.update.success'))
    expect(Storytime::Post.count).to eq(1)

    val = post.value_for_custom_field_named(custom_field.name)
    expect(val).to eq("custom field response value")
  end
  
end
