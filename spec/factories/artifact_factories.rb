FactoryBot.define do
  factory :artifact, class: Storytime::Artifact do
    user
    name { "Test Artifact" }
    content { "<!DOCTYPE html><html><body><h1>Hello artifact</h1></body></html>" }
  end
end
