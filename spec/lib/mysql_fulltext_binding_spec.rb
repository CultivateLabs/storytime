require "spec_helper"

RSpec.describe Storytime::MysqlFulltextSearchAdapter do
  it "keeps SQL operators in search input out of the SQL template" do
    model = double("search model")
    payload = "x' IN NATURAL LANGUAGE MODE)) OR 1=1 -- "
    expect(model).to receive(:where).with("MATCH(content, title) AGAINST (? IN NATURAL LANGUAGE MODE)", payload)
    described_class.search(payload, model)
  end
end
