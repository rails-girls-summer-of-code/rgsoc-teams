FactoryBot.define do
  factory :user, aliases: [:member] do
    github_handle { FFaker::InternetSE.unique.user_name_variant_short }
    sequence(:github_id, 123)
    name     { FFaker::Name.name }
    email    { "#{github_handle}@example.com" }
    hide_email false
    location { FFaker::Address.city }
    country  { FFaker::Address.country }
    bio      { FFaker::Lorem.paragraph }
    homepage { FFaker::Internet.http_url }
    confirmed_at { Date.yesterday }

    factory :coach do
      transient { team { create(:team) } }

      after(:create) do |user, evaluator|
        create(:coach_role, user: user, team: evaluator.team)
      end
    end

    factory :student do
      transient { team { create(:team, :in_current_season) } }

      after(:create) do |user, evaluator|
        create(:student_role, user: user, team: evaluator.team)
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
        application_language_learning_period { ApplicationDraft::MONTHS_LEARNING.sample }
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
      transient { team { create(:team) } }

      after(:create) do |user, evaluator|
        create(:mentor_role, user: user, team: evaluator.team)
      end
    end

    factory :organizer do
      after(:create) do |user|
        create(:organizer_role, user: user)
      end
    end

    factory :helpdesk do
      after(:create) do |user|
        create(:helpdesk_role, user: user)
      end
    end

    factory :developer do
      after(:create) do |user|
        create(:developer_role, user: user)
      end
    end

    factory :supervisor do
      after(:create) do |user|
        create(:supervisor_role, user: user)
      end
    end

    factory :reviewer do
      after(:create) do |user|
        create(:reviewer_role, user: user)
      end
    end

    trait :unconfirmed do
      confirmed_at nil
    end
  end
end
