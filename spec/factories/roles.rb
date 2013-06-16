FactoryGirl.define do
  factory :role do
    team
    member
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
  end
end
