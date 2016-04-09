FactoryGirl.define do
  factory :rating do
    user
    application

    trait :for_team do
      association :rateable, factory: :team
    end
  end
end
