require 'spec_helper'

describe Storytime::Constraints::PageConstraint do
  let(:site) { FactoryBot.create(:site) }
  let(:constraint) { described_class.new }

  def request_for(id)
    instance_double("ActionDispatch::Request", params: { id: id }, host: site.custom_domain)
  end

  before do
    Storytime::Site.current_id = site.id
  end

  after do
    Storytime::Site.current_id = nil
  end

  it "matches an existing page slug" do
    page = FactoryBot.create(:page, site: site)
    expect(constraint.matches?(request_for(page.slug))).to be true
  end

  it "does not match an unknown slug" do
    expect(constraint.matches?(request_for("no-such-page"))).to be false
  end

  context "with a path-traversal payload" do
    let(:payload) { "a/../../../../../../../../etc/passwd" }

    it "does not match" do
      expect(constraint.matches?(request_for(payload))).to be false
    end

    it "never reaches the filesystem check" do
      expect(File).not_to receive(:exist?)
      constraint.matches?(request_for(payload))
    end
  end
end
