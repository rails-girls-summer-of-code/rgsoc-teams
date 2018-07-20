FactoryBot.define do
  factory :comment do
    association :commentable, factory: :project
    user
    text { FFaker::CheesyLingo.paragraph }

    trait :for_application do
      association :commentable, factory: :application
    end

    trait :for_team do
      association :commentable, factory: :team
    end
  end
end
