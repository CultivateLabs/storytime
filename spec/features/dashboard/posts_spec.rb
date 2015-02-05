require 'spec_helper'

describe "In the dashboard, Posts" do
  before{ login_admin }

  it "lists draft posts" do
    3.times{ FactoryGirl.create(:post, published_at: nil) }
    3.times{ FactoryGirl.create(:post, published_at: 2.hours.ago) }
    FactoryGirl.create(:post)
    static_page = FactoryGirl.create(:page)
    visit url_for([:dashboard, Storytime::Post, type: Storytime::BlogPost.type_name, only_path: true])
    
    within "#main" do
      Storytime::Post.primary_feed.each do |p|
        expect(page).to have_content(p.title) if p.published_at.nil?
        expect(page).not_to have_content(p.title) if p.published_at.present?
      end

      expect(page).not_to have_content(static_page.title)
    end
  end
  
  it "creates a post", js: true do
    Storytime::BlogPost.count.should == 0
    media = FactoryGirl.create(:media)

    visit url_for([:new, :dashboard, :post, only_path: true])
    find('#post-title-input').set("The Story")
    click_link "Publish"
    fill_in "post_excerpt", with: "It was a dark and stormy night..."
    find(".note-editable").set("It was a dark and stormy night...")
    # find("#featured_media_id").set media.id
    click_button "Save Draft"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "The Story"
    post.draft_content.should == "<p>It was a dark and stormy night...</p>"
    post.user.should == current_user
    post.should_not be_published
    post.type.should == "Storytime::BlogPost"
    # post.featured_media.should == media
  end

  it "saves a post when previewing a new post", js: true do
    Storytime::BlogPost.count.should == 0

    visit url_for([:new, :dashboard, :post, only_path: true])
    find('#post-title-input').set("Snow Crash")
    click_link "Publish"
    fill_in "post_excerpt", with: "The Deliverator belongs to an elite order, a hallowed sub-category."

    # Use find(".note-editable").set instead of fill_in "post_draft_content" because of Summernote (js)
    find(".note-editable").set "The Deliverator belongs to an elite order, a hallowed sub-category."
    click_link "Cancel"
    click_button "Preview"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "Snow Crash"
    post.draft_content.should == "<p>The Deliverator belongs to an elite order, a hallowed sub-category.</p>"
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
    post = FactoryGirl.create(:post, published_at: nil)
    original_creator = post.user
    Storytime::BlogPost.count.should == 1

    visit url_for([:edit, :dashboard, post, only_path: true])
    find('#post-title-input').set("The Story")
    find(".note-editable").set "It was a dark and stormy night..."
    click_button "Save"
    click_button "Save Draft"
    
    page.should have_content(I18n.t('flash.posts.update.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "The Story"
    post.draft_content.should == "<p>It was a dark and stormy night...</p>"
    post.user.should == original_creator
    post.should_not be_published
  end

  it "deletes a post", js: true do
    3.times{|i| FactoryGirl.create(:post) }
    expect(Storytime::BlogPost.count).to eq(3)

    post = Storytime::BlogPost.first
    visit url_for([:edit, :dashboard, post, only_path: true])
    
    click_button "post-utilities"
    click_link "Delete"

    expect { post.reload }.to raise_error

    expect(page).to_not have_content(post.title)
    expect(Storytime::Post.count).to eq(2)
  end
end
