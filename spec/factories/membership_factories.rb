FactoryGirl.define do
  factory :membership, class: Storytime::Membership do
    user
    site
    storytime_role
  end
end
