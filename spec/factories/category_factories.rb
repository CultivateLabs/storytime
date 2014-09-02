FactoryGirl.define do
  factory :category, class: Storytime::Category do
    sequence(:name) { |i| "Category ##{i}" }
    excluded_from_primary_feed false
  end
end
