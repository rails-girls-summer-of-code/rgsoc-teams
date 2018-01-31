FactoryBot.define do
  factory :application_draft do
    team

    trait :appliable do
      team { create :team, :applying_team }

      association :project1, :accepted, factory: :project
      plan_project1         { FFaker::Lorem.paragraph }
      heard_about_it        { [FFaker::Lorem.paragraph] }
      why_selected_project1 { FFaker::Lorem.paragraph }
      working_together      { FFaker::Lorem.paragraph }
      misc_info             { FFaker::Lorem.paragraph } # NOTE not a required field

      ignore do
        number_of_work_weeks 1
      end

      after(:create) do |draft, evaluator|
        create_list(:application_draft_work_week, evaluator.number_of_work_weeks, application_draft: draft)
        draft.students.each do |student|
          student_update_attributes = (attributes_for :student, :applicant).except(*User.immutable_attributes)
          student.update(student_update_attributes)
        end
      end
    end

    trait :with_two_projects do
      association :project2, :accepted, factory: :project
      why_selected_project2 { FFaker::Lorem.paragraph }
      plan_project2         { FFaker::Lorem.paragraph }
    end

    trait :deprecated_voluntary do
      deprecated_voluntary true
      deprecated_voluntary_hours_per_week 20
    end
  end
end
