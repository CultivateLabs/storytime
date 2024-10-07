require 'spec_helper'

describe "Storytime::PostgresSearchAdapter" do
  before(:each) do
    @blog_posts = FactoryBot.create_list(:post, 3)
    @pages = FactoryBot.create_list(:page, 3)

    Storytime.search_adapter = Storytime::PostgresSearchAdapter
  end

  describe ".search" do
    it "searches all storytime posts for a given search string" do
      expect(Storytime::Post.count).to eq(6)
      expect(Storytime::PostgresSearchAdapter).to receive(:search).with("end").and_return(@blog_posts)

      Storytime.search_adapter.search("end")
    end

    it "searches only the given model" do
      expect(Storytime::Post.count).to eq(6)

      page = FactoryBot.create(:page, content: "Everything bad comes from the mind, because the mind asks too many questions.")
      search_string = "bad mind"

      expect(Storytime::Post.count).to eq(7)
      expect(Storytime::PostgresSearchAdapter).to receive(:search).with(search_string, Storytime::Page).and_return(page)

      Storytime.search_adapter.search(search_string, Storytime::Page)
    end
  end
end