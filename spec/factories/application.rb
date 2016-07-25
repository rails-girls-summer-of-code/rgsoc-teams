FactoryGirl.define do
  factory :application do
    team
    application_data {{
      project_name: FFaker::CheesyLingo.title,
      student0_application_coding_level: 2,
      student1_application_coding_level: 2,
      student_name: FFaker::Name.name,
      location: FFaker::Address.city,
      minimum_money: rand(100),
    }}

    trait :in_current_season do
      season { Season.current }
    end
  end
end
