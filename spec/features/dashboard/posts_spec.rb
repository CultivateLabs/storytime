require 'spec_helper'

describe "In the dashboard, Posts" do
  before do
    login_admin
  end

  it "lists draft posts" do
    blog = @current_site.blogs.first
    3.times{ FactoryGirl.create(:post, blog: blog, site: @current_site, published_at: nil) }
    3.times{ FactoryGirl.create(:post, blog: blog, site: @current_site, published_at: 2.hours.ago) }
    FactoryGirl.create(:post)
    static_page = FactoryGirl.create(:page)

    visit url_for([storytime, :dashboard, blog, :blog_page_post_index, only_path: true])
    
    within "#main" do
      blog.posts.each do |p|
        expect(page).to have_content(p.title) if p.published_at.nil?
        expect(page).not_to have_content(p.title) if p.published_at.present?
      end

      expect(page).not_to have_content(static_page.title)
    end
  end
  
  it "creates a post", js: true do
    post_count = Storytime::BlogPost.count
    media = FactoryGirl.create(:media)
    Rails.logger.warn "==> STARTING CREATE POST"
    visit url_for([:new, :dashboard, @current_site.blogs.first, :blog_post, only_path: true])

    find('#post-title-input').set("The Story")
    find('#medium-editor-post').set("It was a dark and stormy night...")
    
    click_link "Save / Publish"

    fill_in "blog_post_excerpt", with: "It was a dark and stormy night..."
    find("#featured_media_id", visible: false).set media.id
    
    click_button "save-draft-submit"
    
    expect(page).to have_content(I18n.t('flash.posts.create.success'))
    expect(Storytime::BlogPost.count).to eq(post_count + 1)

    post = Storytime::BlogPost.last
    expect(post.title).to eq("The Story")
    expect(post.draft_content).to eq("<p>It was a dark and stormy night...</p>")
    expect(post.user).to eq(current_user)
    expect(post.type).to eq("Storytime::BlogPost")
    expect(post.featured_media).to eq(media)
    expect(post).to_not be_published
  end

  it "saves a post when previewing a new post", js: true do
    post_count = Storytime::BlogPost.count

    visit url_for([:new, :dashboard, @current_site.blogs.first, :blog_post, only_path: true])

    find('#post-title-input').set("Snow Crash")
    find('#medium-editor-post').set("It was a dark and stormy night...")
    find('#blog_post_excerpt', visible: false).set("It was a dark and stormy night...")
    
    click_button "Preview"
    
    expect(page).to have_content(I18n.t('flash.posts.create.success'))
    expect(Storytime::BlogPost.count).to eq(post_count + 1)

    post = Storytime::BlogPost.last
    expect(post.title).to eq("Snow Crash")
    expect(post.draft_content).to eq("<p>It was a dark and stormy night...</p>")
    expect(post.user).to eq(current_user)
    expect(post.type).to eq("Storytime::BlogPost")
    expect(post).to_not be_published
  end

  it "autosaves a post when editing", js: true do
    blog = @current_site.blogs.first
    post = FactoryGirl.create(:post, blog: blog, site: @current_site, published_at: nil,
                              title: "A Scandal in Bohemia",
                              draft_content: "To Sherlock Holmes she was always the woman.")

    original_creator = post.user
    post_count = Storytime::BlogPost.count

    expect(post.autosave).to be_nil

    visit url_for([:edit, :dashboard, post, only_path: true])

    find('#medium-editor-post').set("Some content to autosave")
    
    page.execute_script "Storytime.instance.editor.editor.autosavePostForm()"

    expect(page).to have_content("Draft saved at")

    visit url_for([:edit, :dashboard, post, only_path: true])

    expect(page).to have_content("View the autosave")

    post.reload
    expect(post.autosave).not_to be_nil
    expect(post.autosave.content).to eq("<p>Some content to autosave</p>")
    expect(Storytime::BlogPost.count).to eq(post_count)
  end

  it "updates a post", js: true do
    blog = @current_site.blogs.first
    post = FactoryGirl.create(:post, blog: blog, site: @current_site, published_at: nil)
    original_creator = post.user
    post_count = Storytime::BlogPost.count
    # page.driver.debug

    visit url_for([:edit, :dashboard, post, only_path: true])
    find('#post-title-input').set("The Story")
    find('#medium-editor-post').set("It was a dark and stormy night...")
    click_link "advanced-settings-panel-toggle"
    click_button "Save Draft"

    expect(page).to have_content(I18n.t('flash.posts.update.success'))
    expect(Storytime::BlogPost.count).to eq(post_count)

    post = post.reload
    post.draft_content = nil # clear the cached copy of draft_content so it reloads
    expect(post.title).to eq("The Story")
    expect(post.draft_content).to eq("<p>It was a dark and stormy night...</p>")
    expect(post.user).to eq(original_creator)
    expect(post).to_not be_published
  end

  it "deletes a post", js: true do
    blog = @current_site.blogs.first
    3.times{ FactoryGirl.create(:post, blog: blog, site: @current_site) }
    expect(Storytime::BlogPost.count).to eq(3)

    post = Storytime::BlogPost.first
    visit url_for([:edit, :dashboard, post, only_path: true])
    
    expect{
      click_button "post-utilities"
      click_link "Delete"
    }.to change(Storytime::BlogPost, :count).by(-1)
  end
end
