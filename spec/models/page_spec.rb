require 'spec_helper'

describe Storytime::Page do
  it "Sets the page slug on create" do
    page = FactoryGirl.create(:page)
    page.slug.should == page.title.parameterize
  end
end