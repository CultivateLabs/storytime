require 'spec_helper'

describe "In the dashboard, Snippets" do
  before do 
    login_admin
  end

  it "lists snippets", js: true do
    3.times{ FactoryGirl.create(:snippet) }
    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')
    wait_for_ajax
    
    Storytime::Snippet.all.each do |s|
      expect(page).to have_link(s.name, href: url_for([:edit, :dashboard, s, only_path: true]))
      expect(page).to_not have_content(s.content)
    end
  end
  
  it "creates a snippet", js: true do
    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')
    wait_for_ajax
    click_link "new-snippet-link"
    wait_for_ajax

    expect{
      fill_in "snippet_name", with: "jumbotron-text"
      find(".note-editable").set("Hooray Writing!")
      click_button "Save"
      wait_for_ajax
    }.to change(Storytime::Snippet, :count).by(1)
  end

  it "updates a snippet", js: true do
    snippet = FactoryGirl.create(:snippet, content: "Test")

    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')
    wait_for_ajax

    click_link "edit-snippet-#{snippet.id}"

    fill_in "snippet_name", with: "new-name"
    find(".note-editable").set("It was a dark and stormy night...")
    click_button "Save"
    wait_for_ajax

    snippet.reload
    expect(snippet.name).to eq("new-name")
    expect(snippet.content).to eq("TestIt was a dark and stormy night...")
  end

  it "deletes a snippet", js: true do
    snippet = FactoryGirl.create :snippet

    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')
    wait_for_ajax

    expect{
      find("#snippet_#{snippet.id}").hover()
      click_link "delete_snippet_#{snippet.id}"
      wait_for_ajax
    }.to change(Storytime::Snippet, :count).by(-1)
  end
  
end
