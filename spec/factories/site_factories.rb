FactoryGirl.define do
  factory :site, class: Storytime::Site do
    sequence(:title) {|i| "Site Title #{i}"}
    subscription_email_from "notifications@site.com"
    custom_domain "www.lvh.me"
    post_slug_style 0
  end
end