FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    location { Faker::Address.country }
    bio      { Faker::Lorem.paragraph }
    homepage { Faker::Internet.http_url }
  end
end
