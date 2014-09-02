FactoryGirl.define do
  factory :post, class: Storytime::Post do
    user
    sequence(:title) { |i| "Post ##{i}" }
    sequence(:draft_content) { |i| "Post ##{i}. It was a dark and stormy night. The End." }
    sequence(:excerpt) { |i| "Post ##{i}. It was a dark and stormy night." }
    tag_list ""
    published_at { Time.now }
    type "Storytime::Post"

    factory :page do
      sequence(:title) { |i| "Page ##{i}" }
      type "Storytime::Page"
    end
  end
end
