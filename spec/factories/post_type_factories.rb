FactoryGirl.define do
  factory :post_type, class: Storytime::PostType do
    sequence(:name) { |i| "Post Type ##{i}" }
  end
end
