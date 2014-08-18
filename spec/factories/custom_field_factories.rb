FactoryGirl.define do
  factory :custom_field, class: Storytime::CustomField do
    sequence(:name) { |i| "Custom Field ##{i}" }
    post_type
    type "Storytime::CustomFields::TextField"
    required false
    options_scope nil
  end
end
