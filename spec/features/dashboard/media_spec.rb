require 'spec_helper'

describe "In the dashboard, Images" do
  before{ login }

  def have_image(url)
    have_xpath("//img[@src='#{url}']")
  end
  
  it "creates media" do
    visit new_dashboard_media_path

    attach_file('media_file', "./spec/support/images/success-kid.jpg")

    click_button "Create Media"

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

  it "deletes an image" do
    image = FactoryGirl.create(:media)
    
    visit dashboard_media_index_path
    page.should have_image(image.file_url(:thumb))

    click_link "delete_media_#{image.id}"

    page.should_not have_image(image)

    expect{ image.reload }.to raise_error
  end
end
