FactoryGirl.define do
  factory :membership, class: Storytime::Membership do
    association :user, factory: :user
    association :site, factory: :site
    storytime_role { Storytime::Role.find_by(name: "writer") }
  end
end
