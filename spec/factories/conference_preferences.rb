FactoryGirl.define do
  factory :conference_preference do
    conference_preference_info { FactoryGirl.create(:conference_preference_info) }
    conference { FactoryGirl.create(:conference, :in_current_season) }

    trait :first_choice do
      option 1
    end

    trait :second_choice do
      option 2
    end
  end
end