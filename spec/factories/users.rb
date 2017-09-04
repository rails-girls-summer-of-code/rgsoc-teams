FactoryGirl.define do
  factory :user, aliases: [:member] do
    github_handle { FFaker::Name.name.underscore }
    name     { FFaker::Name.name }
    email    { FFaker::Internet.email }
    location { FFaker::Address.city }
    country  { FFaker::Address.country }
    bio      { FFaker::Lorem.paragraph }
    homepage { FFaker::Internet.http_url }
    confirmed_at { Date.yesterday }

    trait :available do
      availability true
    end

    factory :coach do
      transient { team { FactoryGirl.create(:team) } }

      after(:create) do |user, evaluator|
        FactoryGirl.create(:coach_role, user: user, team: evaluator.team)
      end
    end

    factory :student do
      transient { team { FactoryGirl.create(:team, :in_current_season) } }

      after(:create) do |user, evaluator|
        FactoryGirl.create(:student_role, user: user, team: evaluator.team)
      end

      trait :applicant do
        application_about { FFaker::Lorem.paragraph }
        application_motivation { FFaker::Lorem.paragraph }
        application_gender_identification 'female'
        application_diversity { FFaker::Lorem.paragraph }
        application_age '18-21'
        application_coding_level { (1..5).to_a.sample }
        application_community_engagement { FFaker::Lorem.paragraph }
        application_giving_back { FFaker::Lorem.paragraph }
        application_language_learning_period { User::MONTHS_LEARNING.sample }
        application_learning_history { FFaker::Lorem.paragraph }
        application_skills { FFaker::Lorem.paragraph }
        application_code_samples { FFaker::Lorem.paragraph }
        application_location { FFaker::Address.city }
        application_location_lat { FFaker::Geolocation.lat }
        application_location_lng { FFaker::Geolocation.lng }
        application_minimum_money { FFaker::Lorem.paragraph } # NOTE not a required field
        application_money '850'
        application_goals { FFaker::Lorem.paragraph }
        application_code_background { FFaker::Lorem.paragraph }
      end
    end

    factory :mentor do
      transient { team { FactoryGirl.create(:team) } }

      after(:create) do |user, evaluator|
        FactoryGirl.create(:mentor_role, user: user, team: evaluator.team)
      end
    end

    factory :organizer do
      after(:create) do |user|
        FactoryGirl.create(:organizer_role, user: user)
      end
    end

    factory :helpdesk do
      after(:create) do |user|
        FactoryGirl.create(:helpdesk_role, user: user)
      end
    end

    factory :developer do
      after(:create) do |user|
        FactoryGirl.create(:developer_role, user: user)
      end
    end

    factory :supervisor do
      after(:create) do |user|
        FactoryGirl.create(:supervisor_role, user: user)
      end
    end

    factory :reviewer do
      after(:create) do |user|
        FactoryGirl.create(:reviewer_role, user: user)
      end
    end
  end
end
