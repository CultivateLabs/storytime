require 'spec_helper'

describe "Pages", type: :feature do
  before do
    setup_site(FactoryBot.create(:admin))
  end

  it "shows a page" do
    pg = FactoryBot.create(:page, site: @current_site)
    visit url_for([pg, only_path: true])
    expect(page).to have_content(pg.content)
  end

end
