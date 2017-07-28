FactoryGirl.define do
  factory :conference_preference_info do
    lightning_talk true
    comment { FFaker::Lorem.paragraph }
    team { FactoryGirl.create(:team, :in_current_season, :with_students) }

    trait :with_preferences do
      after(:create) do |cp_info|
        conf1 = FactoryGirl.create(:conference, :in_current_season)
        conf2 = FactoryGirl.create(:conference, :in_current_season)
        cp_info.conference_preferences
               .create(conference_id: conf1.id, option: 1)
        cp_info.conference_preferences
               .create(conference_id: conf2.id, option: 2)
      end
    end

    trait :checked_terms do
      condition_term_ticket true
      condition_term_cost true
    end
  end
end
