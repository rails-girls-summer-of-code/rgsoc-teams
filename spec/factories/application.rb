FactoryGirl.define do
  factory :application do
    user
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    application_data {{
      coding_level: 2,
      student_name: Faker::Name.name,
      location: Faker::Address.city,
      minimum_money: rand(100),
      coding_level_pair: 5,
      hours_per_coach: 3
    }}
  end
end
