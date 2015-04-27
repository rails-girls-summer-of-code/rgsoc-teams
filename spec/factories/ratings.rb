FactoryGirl.define do
  factory :rating do
    user
    association :rateable
  end
end
