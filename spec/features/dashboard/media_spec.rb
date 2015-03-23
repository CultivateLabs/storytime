require 'spec_helper'

describe "In the dashboard, Media" do
  include Storytime::Dashboard::MediaHelper

  before{ login_admin }
  
  it "creates media", js: true do
    visit dashboard_media_index_path

    attach_file('media_file', "./spec/support/images/success-kid.jpg")
    
    expect(find("#media_gallery").find("img")['src']).to have_content('success-kid.jpg')
  end

  it "shows a gallery of the user's images" do
    m1 = FactoryGirl.create(:media, site: @current_site)
    m2 = FactoryGirl.create(:media, site: @current_site)

    visit dashboard_media_index_path
    
    page.should have_image(m1.file_url(:thumb))
    page.should have_image(m2.file_url(:thumb))
  end

  it "deletes an image", js: true do
    image = FactoryGirl.create(:media, site: @current_site)
    
    visit dashboard_media_index_path
    page.should have_image(image.file_url(:thumb))

    click_link "delete_media_#{image.id}"

    page.should_not have_image(image)
  end

  it "inserts media into post", js: true do
    media = FactoryGirl.create(:media, site: @current_site)

    visit url_for([:new, :dashboard, @current_site.blogs.first, :blog_post, only_path: true])

    find(".insert-media-button").click
    
    within "#media_#{media.id}" do
      find(".insert-image-button").click
    end

    expect(page).to have_image(media.file_url)
  end
  
end
