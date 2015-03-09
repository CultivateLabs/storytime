FactoryGirl.define do
  factory :membership, class: Storytime::Membership do
    user
    site
    role
  end
end
