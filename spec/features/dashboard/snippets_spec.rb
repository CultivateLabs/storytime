require 'spec_helper'

describe "In the dashboard, Snippets" do
  before do 
    login_admin
  end

  it "lists snippets", js: true do
    3.times{ FactoryGirl.create(:snippet, site: @current_site) }
    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')
    
    within "#storytime-modal" do
      Storytime::Snippet.all.each do |s|
        expect(page).to have_link(s.name, href: url_for([:edit, :dashboard, s, only_path: true]))
        expect(page).to_not have_content(s.content)
      end
    end
  end
  
  it "creates a snippet", js: true do
    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')
    click_link "new-snippet-link"

    within "#storytime-modal" do
      fill_in "snippet_name", with: "jumbotron-text"
      find("#medium-editor-snippet").set("Hooray Writing!")
      click_button "Save"
    end

    within "#storytime-modal" do
      expect(page).to have_content "jumbotron-text"
    end
  end

  it "updates a snippet", js: true do
    snippet = FactoryGirl.create(:snippet, site: @current_site, content: "Test")

    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')

    click_link "edit-snippet-#{snippet.id}"

    fill_in "snippet_name", with: "new-name"
    find("#medium-editor-snippet").set("It was a dark and stormy night...")
    click_button "Save"

    within "#storytime-modal" do
      expect(page).to have_content "new-name"
    end
  end

  it "deletes a snippet", js: true do
    snippet = FactoryGirl.create :snippet, site: @current_site

    visit storytime.dashboard_url
    find("#snippets-link").trigger('click')

    find("#snippet_#{snippet.id}").hover()
    click_link "delete_snippet_#{snippet.id}"
    
    within "#storytime-modal" do
      expect(page).to_not have_content snippet.name
    end
  end
end
