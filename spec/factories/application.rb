FactoryGirl.define do
  factory :application do
    team
    application_data {{
      student0_name: FFaker::Name.name,
      student1_name: FFaker::Name.name,
      student0_application_coding_level: 2,
      student1_application_coding_level: 2,
      student_name: FFaker::Name.name,
      location: FFaker::Address.city,
      minimum_money: rand(100),
      coaches_hours_per_week: 3
    }}
  end
end
