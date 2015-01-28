require "spec_helper"

describe "In the dashboard, Admin" do
  before do 
    login_admin
  end

  it "redirects with error if model is not configured" do 
    visit dashboard_admin_index_path(resource_name: "things")
    expect(page).to have_content I18n.t('dashboard.admin.unconfigured_model')
  end

  it "lists widgets" do
    3.times{ FactoryGirl.create(:widget) }
    visit dashboard_admin_index_path(resource_name: "widgets")
    
    Widget.all.each do |widget|
      expect(page).to have_content widget.name
    end
  end

  it "creates a widget" do
    visit dashboard_admin_new_path(resource_name: "widgets")

    fill_in :widget_name, with: "New Widget"
    click_button "Save"

    expect(Widget.count).to eq 1
  end

  it "renders the new form with errors if validation fails" do
    visit dashboard_admin_new_path(resource_name: "widgets")

    click_button "Save"

    expect(Widget.count).to eq 0
    expect(page).to have_content "can't be blank"
  end

  it "edits a widget" do
    widget = FactoryGirl.create(:widget)
    visit dashboard_admin_edit_path(resource_name: "widgets", id: widget.id)

    fill_in :widget_name, with: "New Name"
    click_button "Save"

    expect(widget.reload.name).to eq "New Name"
    expect(page).to have_content "New Name"
  end

  it "renders the edit form with errors if validation fails" do
    widget = FactoryGirl.create(:widget)
    old_name = widget.name
    visit dashboard_admin_edit_path(resource_name: "widgets", id: widget.id)

    fill_in :widget_name, with: ""
    click_button "Save"

    expect(widget.reload.name).to eq old_name
    expect(page).to have_content "can't be blank"
  end

  it "deletes a widget" do
    widget1 = FactoryGirl.create(:widget)
    widget2 = FactoryGirl.create(:widget)
    visit dashboard_admin_index_path(resource_name: "widgets")

    expect {
      click_link "delete-widget-#{widget1.id}"
    }.to change(Widget, :count).by(-1)
  end
end