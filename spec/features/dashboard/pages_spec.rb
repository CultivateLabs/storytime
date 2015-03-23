require 'spec_helper'

describe "In the dashboard, Pages" do
  before do 
    login_admin
  end

  describe "index" do
    before do 
      3.times{ FactoryGirl.create(:page, site: current_site) }
      3.times{ FactoryGirl.create(:page, published_at: nil, site: current_site) }
    end

    let!(:other_site_page){ FactoryGirl.create(:page) }

    it "lists draft pages" do
      visit dashboard_pages_path
      
      current_site.pages.each do |p|
        expect(page).to have_link_to_post(p) if p.published_at.nil?
        expect(page).not_to have_link_to_post(p) if p.published_at.present?
        expect(page).not_to have_content(p.content)
      end

      expect(page).not_to have_link_to_post(other_site_page)
    end

    it "lists published pages" do
      visit dashboard_pages_path(published: true)
      
      # need the type designation so Blogs, which are Page subclasses, don't show up in the query
      current_site.pages.where(type: "Storytime::Page").each do |p|
        expect(page).not_to have_link_to_post(p) if p.published_at.nil?
        expect(page).to have_link_to_post(p) if p.published_at.present?
        expect(page).not_to have_content(p.content)
      end

      expect(page).not_to have_link_to_post(other_site_page)
    end
  end
  
  it "creates a page", js: true do
    page_count = Storytime::Page.count

    visit new_dashboard_page_path

    find('#post-title-input').set("The Page")
    find('#medium-editor-post').set("The content of my page")
    
    click_link "Save / Publish"
    click_button "Save Draft"
    
    expect(page).to have_content(I18n.t('flash.posts.create.success'))
    expect(Storytime::Page.count).to eq(page_count + 1)

    pg = Storytime::Page.last
    expect(pg.title).to eq("The Page")
    expect(pg.draft_content).to eq("<p>The content of my page</p>")
    expect(pg.user).to eq(current_user)
    expect(pg.site).to eq(current_site)
    expect(pg.type).to eq("Storytime::Page")
    expect(pg.slug).to eq("The Page".parameterize)
    expect(pg).to_not be_published
  end

  it "updates a page", js: true do
    pg = FactoryGirl.create(:page, site: current_site, published_at: nil)
    original_creator = pg.user
    page_count = Storytime::Page.count
    
    visit edit_dashboard_page_path(pg)
    find('#post-title-input').set("The Story")
    find('#medium-editor-post').set("It was a dark and stormy night...")
    
    click_link "advanced-settings-panel-toggle"
    click_button "Save Draft"
    
    expect(page).to have_content(I18n.t('flash.posts.update.success'))
    expect(Storytime::Page.count).to eq(page_count)

    pg = Storytime::Page.last
    expect(pg.title).to eq("The Story")
    expect(pg.draft_content).to eq("<p>It was a dark and stormy night...</p>")
    expect(pg.user).to eq(original_creator)
    expect(pg.type).to eq("Storytime::Page")
    expect(pg).to_not be_published
  end

  it "deletes a page", js: true do
    storytime_page = FactoryGirl.create(:page, site: current_site)
    page_count = Storytime::Page.count

    visit edit_dashboard_page_path(storytime_page)
    
    click_button "post-utilities"
    click_link "Delete"

    expect(page).to_not have_content(storytime_page.title)
    expect { storytime_page.reload }.to raise_error
    expect(Storytime::Page.count).to eq(page_count - 1)
  end
  
end
