FactoryGirl.define do
  factory :snippet, class: Storytime::Snippet do
    sequence(:name) { |i| "snippet-#{i}" }
    sequence(:content) { |i| "Snippet ##{i}. Fortune favors the bold." }
  end
end
