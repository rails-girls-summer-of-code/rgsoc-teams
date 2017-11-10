FactoryBot.define do
  factory :rating do
    user
    application

    trait :for_application do
      association :rateable, factory: :application
    end
  end
end
