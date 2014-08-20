require 'spec_helper'

describe Storytime::CustomFieldResponse do
  let(:post){ FactoryGirl.create(:post) }
  let(:custom_field){ FactoryGirl.create(:custom_field, post_type: post.post_type) }

  it "cannot create more than one response per post to a custom field" do
    post.custom_field_responses.new(value: "test", custom_field_id: custom_field.id)
    expect(post).to be_valid
    post.custom_field_responses.new(value: "test", custom_field_id: custom_field.id)
    expect(post).not_to be_valid
  end

end