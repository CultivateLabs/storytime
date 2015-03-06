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
    Storytime::BlogPost.count.should == 0
    media = FactoryGirl.create(:media)

    visit url_for([:new, :dashboard, @current_site.blogs.first, :blog_post, only_path: true])

    find('#post-title-input').set("The Story")
    find("[data-input='#blog_post_draft_content']").set("It was a dark and stormy night...")
    click_link "Save / Publish"
    fill_in "blog_post_excerpt", with: "It was a dark and stormy night..."
    # find("#featured_media_id").set media.id
    click_button "Save Draft"

    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "The Story"
    post.draft_content.should == "It was a dark and stormy night..."
    post.user.should == current_user
    post.should_not be_published
    post.type.should == "Storytime::BlogPost"
    # post.featured_media.should == media
  end

  it "saves a post when previewing a new post", js: true do
    Storytime::BlogPost.count.should == 0

    visit url_for([:new, :dashboard, @current_site.blogs.first, :blog_post, only_path: true])

    find('#post-title-input').set("The Story")
    find("[data-input='#blog_post_draft_content']").set("It was a dark and stormy night...")
    click_link "Save / Publish"
    fill_in "blog_post_excerpt", with: "It was a dark and stormy night..."

    click_link "Cancel"
    click_button "Preview"
    
    # page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "Snow Crash"
    post.draft_content.should == "It was a dark and stormy night..."
    post.user.should == current_user
    post.should_not be_published
    post.type.should == "Storytime::BlogPost"
  end

  it "autosaves a post when editing", js: true do
    post = FactoryGirl.create(:post, published_at: nil, title: "A Scandal in Bohemia",
                              draft_content: "To Sherlock Holmes she was always the woman.")
    original_creator = post.user
    Storytime::BlogPost.count.should == 1

    post.autosave.should == nil

    visit url_for([:edit, :dashboard, post, only_path: true])

    page.execute_script "Storytime.instance.editor.autosavePostForm()"

    visit url_for([:edit, :dashboard, post, only_path: true])

    page.should have_content("View the autosave.")

    post.reload
    expect(post.autosave).not_to be_nil
    expect(post.autosave.content).to eq("To Sherlock Holmes she was always the woman.")
  end

  it "updates a post", js: true do
    blog = @current_site.blogs.first
    post = FactoryGirl.create(:post, blog: blog, site: @current_site, published_at: nil)
    original_creator = post.user
    Storytime::BlogPost.count.should == 1

    visit url_for([:edit, :dashboard, post, only_path: true])
    find('#post-title-input').set("The Story")
    find("[data-input='#blog_post_draft_content']").set("It was a dark and stormy night...")
    click_link "advanced-settings-panel-toggle"
    click_button "Save Draft"
    
    # page.should have_content(I18n.t('flash.posts.update.success'))
    Storytime::BlogPost.count.should == 1

    post = post.reload
    post.title.should == "The Story"
    post.draft_content.should == "It was a dark and stormy night..."
    post.user.should == original_creator
    post.should_not be_published
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
