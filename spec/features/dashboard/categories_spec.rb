require 'spec_helper'

describe "In the dashboard, Categories" do
  before{ login_admin }

  it "lists categories" do
    3.times{ FactoryGirl.create(:category) }
    visit dashboard_categories_path
    
    Storytime::Category.all.each do |p|
      page.should have_link(p.name, href: edit_dashboard_category_url(p))
    end
  end
  
  it "creates a category" do
    count = Storytime::Category.count

    visit new_dashboard_category_path
    fill_in "category_name", with: "Travel"
    check "category_excluded_from_primary_feed"
    click_button "Create Category"
    
    page.should have_content(I18n.t('flash.categories.create.success'))
    Storytime::Category.count.should == count+1

    category = Storytime::Category.last
    expect(category.name).to eq("Travel")    
    expect(category.excluded_from_primary_feed).to eq(true)
  end

  it "updates a category" do
    category = FactoryGirl.create(:category)
    original_name = category.name
    count = Storytime::Category.count

    visit edit_dashboard_category_path(category)
    fill_in "category_name", with: "New name"
    click_button "Update Category"
    
    page.should have_content(I18n.t('flash.categories.update.success'))
    Storytime::Category.count.should == count

    expect(Storytime::Category.last.name).to eq("New name")
  end

  it "deletes a category", js: true do
    p1 = FactoryGirl.create(:category)
    p2 = FactoryGirl.create(:category)
    
    visit dashboard_categories_path
    
    click_link("delete_posttype_#{p1.id}")

    page.should_not have_content(p1.name)
    page.should have_content(p2.name)

    expect{ p1.reload }.to raise_error
  end
  
end
