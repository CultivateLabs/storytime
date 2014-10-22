require 'spec_helper'

describe Storytime do
  describe ".snippet" do
    context "when the snippet doesn't exist" do
      it "returns a blank string" do
        expect(Storytime.snippet("missing")).to be_blank
      end
    end

    context "when the snippet exists" do
      let(:snippet){ FactoryGirl.create(:snippet) }
      let(:returned_content){ Storytime.snippet(snippet.name) }
      it "returns the content of a snippet with the passed name" do
        expect(returned_content).to eq(snippet.content)
      end

      it "returns an html safe string" do
        expect(returned_content).to be_html_safe
      end
    end
  end
end