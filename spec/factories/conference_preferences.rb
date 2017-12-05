FactoryBot.define do
  factory :conference_preference do
    association :team, :in_current_season
    association :first_conference, factory: :conference
    association :second_conference, factory: :conference
    terms_of_ticket true
    terms_of_travel true

    trait :student_preference do
      after(:create) do |preference|
        preference.team.roles.create name: 'student', user: create(:user)
        preference
      end
    end
  end
end
