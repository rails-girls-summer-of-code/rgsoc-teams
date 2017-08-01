FactoryGirl.define do
  factory :conference_preference do
    team { FactoryGirl.create(:team, :in_current_season) }
    first_conference { FactoryGirl.create(:conference, :in_current_season) }
    second_conference { FactoryGirl.create(:conference, :in_current_season) }

    trait :student_preference do
      after(:create) do |preference|
        preference.team.roles.create name: "student", user: create(:user)
        preference
      end
    end
  end
end
