FactoryGirl.define do
  factory :role do
    team
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

    factory :supervisor_role do
      name 'supervisor'
    end
    
  end
end
