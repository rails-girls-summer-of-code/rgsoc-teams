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
  end
end
