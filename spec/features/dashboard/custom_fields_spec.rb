require 'spec_helper'

describe "In the dashboard, CustomFields" do
  before{ login_admin }

  let(:post_type){ FactoryGirl.create(:post_type) }

  it "can be added to a post type", js: true do
    expect(post_type.custom_fields.count).to eq(0)
    visit edit_dashboard_post_type_path(post_type)

    click_link "Add Custom Field"

    type_select = find("select[id^='post_type_custom_fields_attributes_'][id$='_type']")
    type_select.find("option[value='Storytime::CustomFields::TextField']").select_option

    find("input[id^='post_type_custom_fields_attributes_'][id$='_name']").set("Superpower")
    find("input[id^='post_type_custom_fields_attributes_'][id$='_required']").set(true)
    
    expect(page).to_not have_content("Options Scope")
    
    click_button "Update Post type"

    expect(page).to have_content(I18n.t('flash.post_types.update.success'))

    post_type.reload
    expect(post_type.custom_fields.count).to eq(1)

    field = Storytime::CustomField.last
    expect(field.type).to eq("Storytime::CustomFields::TextField")
    expect(field.name).to eq("Superpower")
    expect(field.required).to be_true
  end

  it "can be updated", js: true do
    post_type = FactoryGirl.create(:post_type)
    field = FactoryGirl.create(:custom_field, post_type: post_type)
    expect(post_type.custom_fields.count).to eq(1)
    
    visit edit_dashboard_post_type_path(post_type)

    type_select = find("select[id^='post_type_custom_fields_attributes_'][id$='_type']")
    type_select.find("option[value='Storytime::CustomFields::TextField']").select_option

    find("input[id^='post_type_custom_fields_attributes_'][id$='_name']").set("Superpower")
    find("input[id^='post_type_custom_fields_attributes_'][id$='_required']").set(true)
    
    click_button "Update Post type"
    
    expect(page).to have_content(I18n.t('flash.post_types.update.success'))

    post_type.reload
    expect(post_type.custom_fields.count).to eq(1)

    field = Storytime::CustomField.last
    expect(field.type).to eq("Storytime::CustomFields::TextField")
    expect(field.name).to eq("Superpower")
    expect(field.required).to be_true
  end

  it "can be removed from a post_type", js: true do
    post_type = FactoryGirl.create(:post_type)
    field = FactoryGirl.create(:custom_field, post_type: post_type)
    expect(post_type.custom_fields.count).to eq(1)
    
    visit edit_dashboard_post_type_path(post_type)

    find(".remove_fields").click
    click_button "Update Post type"
    
    expect(page).to have_content(I18n.t('flash.post_types.update.success'))

    post_type.reload
    expect(post_type.custom_fields.count).to eq(0)

    expect{ field.reload }.to raise_error
  end
  
end
