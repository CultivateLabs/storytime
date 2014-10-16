FactoryGirl.define do
  factory :post, class: Storytime::BlogPost do
    user
    sequence(:title) { |i| "Post ##{i}" }
    sequence(:draft_content) { |i| "Post ##{i}. It was a dark and stormy night. The End." }
    sequence(:content) { |i| "Post ##{i}. It was a dark and stormy night. The End." }
    sequence(:excerpt) { |i| "Post ##{i}. It was a dark and stormy night." }
    tag_list [""]
    published_at { Time.now }

    factory :page, class: Storytime::Page do
      sequence(:title) { |i| "Page ##{i}" }
    end
  end
end
