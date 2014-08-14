FactoryGirl.define do
  factory :post_type, class: Storytime::PostType do
    sequence(:name) { |i| "Post Type ##{i}" }
    excluded_from_primary_feed false
  end
end
