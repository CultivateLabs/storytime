require 'spec_helper'
require 'pry'
describe "In the dashboard, Posts" do
  before{ login_admin }

  it "lists posts" do
    3.times{ FactoryGirl.create(:post) }
    FactoryGirl.create(:post)
    static_page = FactoryGirl.create(:page)
    visit url_for([:dashboard, Storytime::Post, type: Storytime::BlogPost.type_name, only_path: true])
    
    within "#list" do
      Storytime::Post.primary_feed.each do |p|
        expect(page).to have_content(p.title)
      end

      expect(page).not_to have_content(static_page.title)
    end
  end
  
  it "creates a post" do
    Storytime::BlogPost.count.should == 0
    media = FactoryGirl.create(:media)

    visit url_for([:new, :dashboard, :post])
    fill_in "post_title", with: "The Story"
    fill_in "post_excerpt", with: "It was a dark and stormy night..."
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    find("#featured_media_id").set media.id
    click_button "Save Draft"
    
    page.should have_content(I18n.t('flash.posts.create.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "The Story"
    post.draft_content.should == "It was a dark and stormy night..."
    post.user.should == current_user
    post.should_not be_published
    post.type.should == "Storytime::BlogPost"
    post.featured_media.should == media
  end

  it "saves a post when previewing a new post", js: true do
    Storytime::BlogPost.count.should == 0

    visit url_for([:new, :dashboard, :post, only_path: true])
    fill_in "post_title", with: "Snow Crash"
    fill_in "post_excerpt", with: "The Deliverator belongs to an elite order, a hallowed sub-category."

    find(".note-editable").set "The Deliverator belongs to an elite order, a hallowed sub-category."
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

  it "updates a post" do
    post = FactoryGirl.create(:post, published_at: nil)
    original_creator = post.user
    Storytime::BlogPost.count.should == 1

    visit url_for([:edit, :dashboard, post, only_path: true])
    fill_in "post_title", with: "The Story"
    fill_in "post_draft_content", with: "It was a dark and stormy night..."
    click_button "Save Draft"
    
    page.should have_content(I18n.t('flash.posts.update.success'))
    Storytime::BlogPost.count.should == 1

    post = Storytime::BlogPost.last
    post.title.should == "The Story"
    post.draft_content.should == "It was a dark and stormy night..."
    post.user.should == original_creator
    post.should_not be_published
  end

  it "deletes a post", js: true do
    3.times{|i| FactoryGirl.create(:post) }
    visit url_for([:dashboard, Storytime::BlogPost, only_path: true])
    p1 = Storytime::BlogPost.first
    p2 = Storytime::BlogPost.last
    
    click_link("delete_blogpost_#{p1.id}")

    page.should_not have_content(p1.title)
    page.should have_content(p2.title)

    expect{ p1.reload }.to raise_error
  end
  
end
