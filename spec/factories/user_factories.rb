FactoryGirl.define do
  factory :user, class: Storytime::User do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"
    role

    factory :writer, class: Storytime::User do
      association :role, factory: :writer_role
    end

    factory :editor, class: Storytime::User do
      association :role, factory: :editor_role
    end

    factory :admin, class: Storytime::User do
      association :role, factory: :admin_role
    end
  end
end
