require 'spec_helper'

describe "In the dashboard, Media", type: :feature do
  include Storytime::Dashboard::MediaHelper

  before{ login_admin }

  it "creates media", js: true do
    visit dashboard_media_index_path

    attach_file('media_file', "./spec/support/images/success-kid.jpg")

    expect(find("#media_gallery").find("img")['src']).to have_content('success-kid.jpg')
  end

  it "shows a gallery of the user's images" do
    m1 = FactoryBot.create(:media, site: @current_site)
    m2 = FactoryBot.create(:media, site: @current_site)

    visit dashboard_media_index_path

    expect(page).to have_image(m1.file_url(:thumb))
    expect(page).to have_image(m2.file_url(:thumb))
  end

  it "deletes an image", js: true do
    image = FactoryBot.create(:media, site: @current_site)

    visit dashboard_media_index_path
    expect(page).to have_image(image.file_url(:thumb))

    click_link "delete_media_#{image.id}"

    expect(page).to_not have_image(image)
  end

  it "inserts media into post", js: true do
    media = FactoryBot.create(:media, site: @current_site)

    visit url_for([:new, :dashboard, @current_site.blogs.first, :blog_post, only_path: true])

    find(".insert-media-button").click

    within "#media_#{media.id}" do
      find(".insert-image-button").click
    end

    expect(page).to have_image(media.file_url)
  end

end
