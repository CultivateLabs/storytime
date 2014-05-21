FactoryGirl.define do
  factory :permission, class: Storytime::Permission do
    role
    action
  end
end