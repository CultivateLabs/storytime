require 'spec_helper'

describe "In the dashboard, Media" do
  include Storytime::Dashboard::MediaHelper

  # needed because our wysiwyg text area is hidden
  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time + 5) do
      sleep(0.1) until value = yield
      value
    end
  end

  before{ login }
  
  it "creates media", js: true do
    visit dashboard_media_index_path

    attach_file('media_file', "./spec/support/images/success-kid.jpg")

    
    media = Storytime::Media.last
    page.should have_image(media.file_url(:thumb))
  end

  it "shows a gallery of the user's images" do
    m1 = FactoryGirl.create(:media)
    m2 = FactoryGirl.create(:media)

    visit dashboard_media_index_path
    
    page.should have_image(m1.file_url(:thumb))
    page.should have_image(m2.file_url(:thumb))
  end

  it "deletes an image", js: true do
    image = FactoryGirl.create(:media)
    
    visit dashboard_media_index_path
    page.should have_image(image.file_url(:thumb))

    click_link "delete_media_#{image.id}"

    page.should_not have_image(image)

    expect{ image.reload }.to raise_error
  end

  it "inserts media into post", js: true do
    media = FactoryGirl.create(:media)

    visit url_for([:new, :dashboard, :post, type: Storytime::BlogPost.type_name, only_path: true])

    find(".insert-media-button").click

    within "#media_#{media.id}" do
      find(".insert-image-button").click
    end

    expect(page).to have_image(media.file_url)
  end
  
end
