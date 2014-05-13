require 'spec_helper'

describe "In the dashboard, Media" do
  include Storytime::MediaHelper

  before{ login }

  def have_image(url)
    have_xpath("//img[@src='#{url}']")
  end
  
  it "creates media", js: true do
    visit dashboard_media_index_path

    attach_file('media_file', "./spec/support/images/success-kid.jpg")

    page.should have_selector("#media_gallery img")
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

    visit new_dashboard_post_path

    page.should have_selector("a[data-wysihtml5-command='insertImage']")
    find("a[data-wysihtml5-command='insertImage']").click

    page.should have_selector("#insertMediaModal")
    find(".insert-image-button").click

    page.should_not have_selector("#insertMediaModal")
    find("#post_content", visible: false).value.should =~ /#{media.file_url}/
  end
  
end
