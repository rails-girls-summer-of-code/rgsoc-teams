FactoryGirl.define do
  factory :application do
    team
    name     { FFaker::Name.name }
    email    { FFaker::Internet.email }
    application_data {{
      coding_level: 2,
      student_name: FFaker::Name.name,
      location: FFaker::Address.city,
      minimum_money: rand(100),
      coding_level_pair: 5,
      hours_per_coach: 3
    }}
  end
end
