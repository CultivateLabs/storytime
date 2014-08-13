FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"
    sequence(:storytime_name) { |i| "user name #{i}" }

    factory :writer do
      before(:create){|user| user.storytime_role = Storytime::Role.find_by(name: "writer") }
    end

    factory :editor do
      before(:create){|user| user.storytime_role = Storytime::Role.find_by(name: "editor") }
    end

    factory :admin do
      before(:create){|user| user.storytime_role = Storytime::Role.find_by(name: "admin") }
    end
  end
end
