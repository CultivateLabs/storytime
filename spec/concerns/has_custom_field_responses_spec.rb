require 'spec_helper'

describe Storytime::Post do
  let(:post){ FactoryGirl.create(:post) }
  let(:custom_field){ FactoryGirl.create(:custom_field, post_type: post.post_type) }

  it "cannot create more than one response per post to a custom field" do
    post.custom_field_responses.new(value: "test", custom_field_id: custom_field.id)
    expect(post).to be_valid
    post.custom_field_responses.new(value: "test", custom_field_id: custom_field.id)
    expect(post).not_to be_valid
  end

  describe "#initialize_missing_custom_field_responses" do
    it "adds response objects for any custom field that is currently missing from responses" do
      custom_field2 = FactoryGirl.create(:custom_field, post_type: post.post_type)
      other_type_custom_field = FactoryGirl.create(:custom_field)
      response = post.custom_field_responses.new(value: "test", custom_field_id: custom_field.id)

      expect(post.custom_field_responses.length).to eq(1)
      expect(post.custom_field_responses.map{|resp| [resp.custom_field_id, resp.post_id]}).to match_array([[custom_field.id, post.id]])

      post.initialize_missing_custom_field_responses

      expect(post.custom_field_responses.length).to eq(2)
      expect(post.custom_field_responses.map{|resp| [resp.custom_field_id, resp.post_id]}).to match_array([[custom_field.id, post.id], [custom_field2.id, post.id]])
    end
  end

  describe "#value_for_custom_field_named" do
    it "returns the value if a response exists" do
      response = post.custom_field_responses.create(value: "flyoverworks", custom_field_id: custom_field.id)

      val = post.value_for_custom_field_named(custom_field.name)
      expect(val).to eq("flyoverworks")
    end

    it "returns nil if a response does not exist" do
      val = post.value_for_custom_field_named("missing")
      expect(val).to eq(nil)
    end
  end
end