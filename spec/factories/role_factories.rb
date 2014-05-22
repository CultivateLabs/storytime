FactoryGirl.define do
  factory :role, class: Storytime::Role do
    name 'writer'

    factory :writer_role, class: Storytime::Role do
      name 'writer'

      after(:create) do |role, evaluator|
        ["Publish Own Posts/Pages"].each do |name|
          action = FactoryGirl.create(:action, name: name)
          FactoryGirl.create(:permission, role: role, action: action)
        end
      end
    end

    factory :editor_role, class: Storytime::Role do
      name 'editor'

      after(:create) do |role, evaluator|
        ["Publish Own Posts/Pages", "Manage Others' Posts/Pages"].each do |name|
          action = FactoryGirl.create(:action, name: name)
          FactoryGirl.create(:permission, role: role, action: action)
        end
      end
    end

    factory :admin_role, class: Storytime::Role do
      name 'admin'

      after(:create) do |role, evaluator|
        ["Publish Own Posts/Pages", "Manage Others' Posts/Pages", "Manage Site Settings", "Manage Users"].each do |name|
          action = FactoryGirl.create(:action, name: name)
          FactoryGirl.create(:permission, role: role, action: action)
        end
      end
    end
  end
end