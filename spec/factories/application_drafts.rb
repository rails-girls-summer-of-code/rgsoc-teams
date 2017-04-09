FactoryGirl.define do
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

      after(:create) do |draft|
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

    trait :voluntary do
      voluntary true
      voluntary_hours_per_week 20
    end
  end
end
