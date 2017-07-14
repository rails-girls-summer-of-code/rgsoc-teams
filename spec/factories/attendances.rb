FactoryGirl.define do
  factory :attendance do
	  team { FactoryGirl.create(:team, :in_current_season) }
	  conference { FactoryGirl.create(:conference, :in_current_season) }

    trait :student_attendance do
      after(:create) do |attendance|
        attendance.team.roles.create name: "student", user: create(:user)
        attendance
      end
    end
  end
end
