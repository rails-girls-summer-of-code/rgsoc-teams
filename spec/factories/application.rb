FactoryBot.define do
  factory :application do
    team
    application_data {{
      student0_application_coding_level: 2,
      student1_application_coding_level: 2,
      student_name: FFaker::Name.name,
      work_week_ids: [create(:work_week).id],
      location: FFaker::Address.city,
      minimum_money: rand(100),
    }}

    trait :in_current_season do
      season { Season.current }
    end

    trait :for_project do
      transient do
        project1 nil
        project2 nil
      end

      application_data {{
        'project1_id': project1&.id&.to_s,
        'project2_id': project2&.id&.to_s,
        'plan_project1': FFaker::Lorem.paragraph,
        'plan_project2': (project2.nil? ? FFaker::Lorem.paragraph : ''),
        'why_selected_project1': FFaker::Lorem.paragraph,
        'why_selected_project2': (project2.nil? ? FFaker::Lorem.paragraph : ''),

        'student0_application_coding_level': '1',
        'student0_application_code_samples': FFaker::Lorem.paragraph,
        'student0_application_learning_history': FFaker::Lorem.paragraph,
        'student0_application_skills': FFaker::Lorem.paragraph,
        'student0_application_language_learning_period': ApplicationDraft::MONTHS_LEARNING.sample,

        'student1_application_coding_level': '5',
        'student1_application_code_samples': FFaker::Lorem.paragraph,
        'student1_application_learning_history': FFaker::Lorem.paragraph,
        'student1_application_skills': FFaker::Lorem.paragraph,
        'work_week_ids': [create(:work_week).id],
        'student1_application_language_learning_period': ApplicationDraft::MONTHS_LEARNING.sample
      }}
    end

    trait :skip_validations do
      to_create {|instance| instance.save(validate: false) }
    end
  end
end
