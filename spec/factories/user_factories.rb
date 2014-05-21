FactoryGirl.define do
  factory :user, class: Storytime::User do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"
    role 'writer'

    factory :writer, class: Storytime::User do
      role 'writer'
    end

    factory :editor, class: Storytime::User do
      role 'editor'
    end

    factory :admin, class: Storytime::User do
      role 'admin'
    end
  end
end
