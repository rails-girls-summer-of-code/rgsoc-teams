FactoryGirl.define do
  factory :application do
    user
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    application_data { {coding_level: 2} }
  end
end
