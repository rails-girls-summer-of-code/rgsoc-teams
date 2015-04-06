FactoryGirl.define do
  factory :user, aliases: [:member] do
    github_handle { FFaker::Name.name.underscore }
    name     { FFaker::Name.name }
    email    { FFaker::Internet.email }
    location { FFaker::Address.city }
    country  { FFaker::Address.country }
    bio      { FFaker::Lorem.paragraph }
    homepage { FFaker::Internet.http_url }

    factory :coach do
      after(:create) do |user|
        FactoryGirl.create(:coach_role, user: user)
      end
    end

    factory :student do
      after(:create) do |user|
        FactoryGirl.create(:student_role, user: user)
      end

      trait :applicant do
        application_about { FFaker::Lorem.paragraph }
        application_motivation { FFaker::Lorem.paragraph }
        application_gender_identification 'female'
        application_coding_level { (1..5).to_a.sample }
        application_community_engagement { FFaker::Lorem.paragraph }
        application_learning_period { User::MONTHS_LEARNING.sample }
        application_learning_history { FFaker::Lorem.paragraph }
        application_skills{ FFaker::Lorem.paragraph }
        application_code_samples{ FFaker::Lorem.paragraph }
        application_location{ FFaker::Address.city }
        application_minimum_money { FFaker::Lorem.paragraph }
        banking_info { FFaker::Lorem.paragraph }
      end
    end

    factory :mentor do
      after(:create) do |user|
        FactoryGirl.create(:mentor_role, user: user)
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

    factory :supervisor do
      after(:create) do |user|
        FactoryGirl.create(:supervisor_role, user: user)
      end
    end
  end
end
