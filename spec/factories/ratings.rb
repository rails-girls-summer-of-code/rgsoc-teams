FactoryGirl.define do
  factory :rating do
    user
    application

    trait :for_student do
      association :rateable, factory: :studetn
    end

    trait :for_team do
      association :rateable, factory: :team
    end

    trait :for_application do
      association :rateable, factory: :application
    end
  end
end
