# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :form_application do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end