FactoryGirl.define do
  factory :conference_preference do
    team { FactoryGirl.create(:team, :in_current_season) }
    first_conference { FactoryGirl.create(:conference, :in_current_season) }
    second_conference { FactoryGirl.create(:conference, :in_current_season) }

    trait :student_preference do
      after(:create) do |preference|
        preference.team.roles.create name: 'student', user: create(:user)
        preference
      end
    end

    trait :with_terms_checked do
      terms_of_ticket '1'
      terms_of_travel '1'
    end
  end
end
