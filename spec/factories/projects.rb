# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name { FFaker::Product.product_name }
    association :submitter, factory: :user
    mentor_name { FFaker::Product.product_name }
    mentor_github_handle { FFaker::Internet.user_name }
    mentor_email { FFaker::Internet.email }
    url { FFaker::Internet.http_url }
    description { FFaker::HipsterIpsum.paragraph }
    issues_and_features { FFaker::Internet.email }
    beginner_friendly true
    trait :accepted do
      after(:create) { |record| record.accept! }
    end

    trait :rejected do
      after(:create) { |record| record.reject! }
    end

    trait :in_current_season do
      season { Season.current }
    end
  end
end
