FactoryGirl.define do
  factory :subscription, class: Storytime::Subscription do
    sequence(:email) { |n| "test_user_#{n}@example.com" }
  end
end