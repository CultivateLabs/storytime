FactoryBot.define do
  factory :api_token, class: Storytime::ApiToken do
    user
    sequence(:name) { |i| "Token #{i}" }
  end
end
