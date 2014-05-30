FactoryGirl.define do
  factory :user, class: Storytime.user_class do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"

    factory :writer, class: Storytime.user_class do
      before(:create){|user| user.storytime_role = Storytime::Role.find_by(name: "writer") }
    end

    factory :editor, class: Storytime.user_class do
      before(:create){|user| user.storytime_role = Storytime::Role.find_by(name: "editor") }
    end

    factory :admin, class: Storytime.user_class do
      before(:create){|user| user.storytime_role = Storytime::Role.find_by(name: "admin") }
    end
  end
end
