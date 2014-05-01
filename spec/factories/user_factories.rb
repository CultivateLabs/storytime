FactoryGirl.define do
  factory :user, class: Storytime::User do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"
  end
end
