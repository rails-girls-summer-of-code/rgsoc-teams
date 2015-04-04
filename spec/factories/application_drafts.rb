FactoryGirl.define do
  factory :application_draft do
    team

    trait :appliable do
      team { create :team, :applying_team }

      coaches_why_team_successful { FFaker::Lorem.paragraph }
      project_name { FFaker::Movie.title }
      project_url { FFaker::Internet.http_url }
      heard_about_it { FFaker::Lorem.paragraph }
      # voluntary_hours_per_week 20 # TODO marked as required, but only needed for voluntary == true

      after(:create) do |draft|
        draft.students.each do |student|
          student.update(attributes_for :student, :applicant)
        end
      end

    end
  end
end
