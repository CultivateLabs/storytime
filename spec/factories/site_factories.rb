FactoryGirl.define do
  factory :site, class: Storytime::Site do
    sequence(:title) {|i| "Site Title #{i}"}
    post_slug_style 0
  end
end
