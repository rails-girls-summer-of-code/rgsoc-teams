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
