require 'spec_helper'

describe Storytime::Navigation do
  describe "#handle" do
    it "parameterizes the title to set the handle" do
      nav = FactoryGirl.create(:navigation, handle: nil)
      expect(nav.handle).to eq nav.name.parameterize
    end

    it "parameterizes the handle" do
      nav = FactoryGirl.create(:navigation, handle: "my Handle")
      expect(nav.handle).to eq "my-handle"
    end

    it "does not change the handle if the title changes" do
      nav = FactoryGirl.create(:navigation, handle: "my Handle")
      nav.update(name: "New Name")
      expect(nav.handle).to eq "my-handle"
    end
  end
end