require 'spec_helper'

describe "In the dashboard, PostTypes" do
  before{ login_admin }

  it "lists post types" do
    3.times{ FactoryGirl.create(:post_type) }
    visit dashboard_post_types_path
    
    Storytime::PostType.all.each do |p|
      page.should have_link(p.name, href: edit_dashboard_post_type_url(p))
    end
  end
  
  it "creates a post_type" do
    count = Storytime::PostType.count

    visit new_dashboard_post_type_path
    fill_in "post_type_name", with: "Travel"
    click_button "Create Post type"
    
    page.should have_content(I18n.t('flash.post_types.create.success'))
    Storytime::PostType.count.should == count+1

    expect(Storytime::PostType.last.name).to eq("Travel")    
  end

  it "updates a post_type" do
    post_type = FactoryGirl.create(:post_type)
    original_name = post_type.name
    count = Storytime::PostType.count

    visit edit_dashboard_post_type_path(post_type)
    fill_in "post_type_name", with: "New name"
    click_button "Update Post type"
    
    page.should have_content(I18n.t('flash.post_types.update.success'))
    Storytime::PostType.count.should == count

    expect(Storytime::PostType.last.name).to eq("New name")
  end

  it "deletes a post_type", js: true do
    3.times{|i| FactoryGirl.create(:post_type) }
    visit dashboard_post_types_path
    p1 = Storytime::PostType.first
    p2 = Storytime::PostType.last
    click_link("delete_posttype_#{p1.id}")

    page.should_not have_content(p1.name)
    page.should have_content(p2.name)

    expect{ p1.reload }.to raise_error
  end
  
end
