require 'spec_helper'
require 'pry'

include Storytime::StorytimeHelpers

describe "Storytime::StorytimeHelpers", :type => :helper do
  describe "storytime_snippet" do
    before(:each) do
      @site = FactoryGirl.create(:site)
      expect_any_instance_of(Storytime::StorytimeHelpers).to receive(:current_storytime_site).at_least(:once).and_return(@site)
      expect_any_instance_of(ApplicationHelper).to receive(:logged_in_storytime_user?).at_least(:once).and_return(false)
    end

    describe "when no snippet is found" do
      it "creates snippet from I18n translation with same name" do
        existing_translation = storytime_snippet("layout.title")

        expect(storytime_snippet("layout.title")).to include("Storytime")
      end

      it "creates snippet with 'Lorem ipsum' placeholder text" do
        missing_translation_div = storytime_snippet("nothing.here")

        expect(missing_translation_div).to include("Lorem ipsum dolor sit amet, consectetur adipiscing elit...")
      end
    end

    describe "when snippet is found" do
      it "returns snippet partial" do
        snippet = FactoryGirl.create(:snippet, site: @site)
        snippet_div = storytime_snippet(snippet.name)

        expect(snippet_div).to include(snippet.content)
      end
    end
  end
end