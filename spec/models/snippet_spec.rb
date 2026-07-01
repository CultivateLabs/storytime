require 'spec_helper'

describe Storytime::Snippet do
  describe "#sanitize_content" do
    it "strips script-bearing attributes from content on save" do
      snippet = FactoryBot.create(:snippet, content: %(<img src=x onerror="alert(1)">))
      expect(snippet.content).to_not include("onerror")
    end

    it "strips <script> tags from content on save" do
      snippet = FactoryBot.create(:snippet, content: %(hello<script>alert(1)</script>))
      expect(snippet.content).to_not include("<script")
    end

    it "re-sanitizes content on update" do
      snippet = FactoryBot.create(:snippet, content: "safe")
      snippet.update(content: %(<a href="javascript:alert(1)">x</a>))
      expect(snippet.content).to_not include("javascript:")
    end

    it "preserves allowed markup" do
      snippet = FactoryBot.create(:snippet, content: %(<p>hello <strong>world</strong></p>))
      expect(snippet.content).to include("<strong>world</strong>")
    end

    it "leaves plain text unchanged" do
      snippet = FactoryBot.create(:snippet, content: "just plain text")
      expect(snippet.content).to eq("just plain text")
    end
  end
end
