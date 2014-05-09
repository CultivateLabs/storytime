FactoryGirl.define do
  factory :page, class: Storytime::Page do
    user
    sequence(:title) { |i| "Post ##{i}" }
    sequence(:slug) { |i| "page-#{i}" }
    sequence(:content) { |i| "Page ##{i}. It was a dark and stormy night. The End." }
    published true
  end
end