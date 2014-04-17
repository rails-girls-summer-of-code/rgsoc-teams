FactoryGirl.define do
  factory :application do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    application_data { Hash.new }
  end
end
