FactoryGirl.define do
  factory :comment, class: Storytime::Comment do
    user
    post
    sequence(:content) { |i| "Comment ##{i}" }
    site
  end
end
