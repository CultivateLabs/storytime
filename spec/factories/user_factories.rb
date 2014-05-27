FactoryGirl.define do
  factory :user, class: Storytime::User do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"

    factory :writer, class: Storytime::User do
      before(:create){|user| user.role = Storytime::Role.find_by(name: "writer") }
    end

    factory :editor, class: Storytime::User do
      before(:create){|user| user.role = Storytime::Role.find_by(name: "editor") }
    end

    factory :admin, class: Storytime::User do
      before(:create){|user| user.role = Storytime::Role.find_by(name: "admin") }
    end
  end
end
