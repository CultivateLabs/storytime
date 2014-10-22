require 'spec_helper'

describe "In the dashboard, Snippets" do
  before do 
    login_admin
  end

  it "lists snippets" do
    3.times{ FactoryGirl.create(:snippet) }
    visit url_for([:dashboard, Storytime::Snippet])
    
    Storytime::Snippet.all.each do |s|
      expect(page).to have_link(s.name, href: url_for([:edit, :dashboard, s, only_path: true]))
      expect(page).to_not have_content(s.content)
    end
  end
  
  it "creates a snippet" do
    expect(Storytime::Snippet.count).to eq(0)

    visit url_for([:new, :dashboard, :snippet, only_path: true])
    fill_in "snippet_name", with: "jumbotron-text"
    fill_in "snippet_content", with: "Hooray Writing!"
    
    click_button "Create Snippet"
    
    expect(page).to have_content(I18n.t('flash.snippets.create.success'))
    expect(Storytime::Snippet.count).to eq(1)

    snippet = Storytime::Snippet.last
    expect(snippet.name).to eq("jumbotron-text")
    expect(snippet.content).to eq("Hooray Writing!")
  end

  it "updates a snippet" do
    snippet = FactoryGirl.create(:snippet)
    expect(Storytime::Snippet.count).to eq(1)
    
    visit url_for([:edit, :dashboard, snippet])
    fill_in "snippet_name", with: "new-name"
    fill_in "snippet_content", with: "It was a dark and stormy night..."
    click_button "Update Snippet"
    
    expect(page).to have_content(I18n.t('flash.snippets.update.success'))
    expect(Storytime::Snippet.count).to eq(1)

    snippet = Storytime::Snippet.last
    expect(snippet.name).to eq("new-name")
    expect(snippet.content).to eq("It was a dark and stormy night...")
  end

  it "deletes a snippet", js: true do
    3.times{|i| FactoryGirl.create(:snippet) }
    visit url_for([:dashboard, Storytime::Snippet, only_path: true])
    s1 = Storytime::Snippet.first
    s2 = Storytime::Snippet.last
    click_link("delete_snippet_#{s1.id}")

    expect(page).to_not have_content(s1.name)
    expect(page).to have_content(s2.name)

    expect{ s1.reload }.to raise_error
  end
  
end
