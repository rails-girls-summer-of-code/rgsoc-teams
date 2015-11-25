# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name { FFaker::Product.product_name }
    association :submitter, factory: :user

    trait :accepted do
      after(:create) { |record| record.accept! }
    end

    trait :rejected do
      after(:create) { |record| record.reject! }
    end
  end
end
