FactoryGirl.define do
  factory :role do
    association :team, :in_current_season
    user
    name { Role::ROLES.sample }

    factory :student_role do
      name 'student'
    end

    factory :coach_role do
      name 'coach'
    end

    factory :mentor_role do
      name 'mentor'
    end

    factory :organizer_role do
      name 'organizer'
    end

    factory :helpdesk_role do
      name 'helpdesk'
    end

    factory :developer_role do
      name 'developer'
    end

    factory :supervisor_role do
      name 'supervisor'
    end

    factory :reviewer_role do
      name 'reviewer'
    end

  end
end
