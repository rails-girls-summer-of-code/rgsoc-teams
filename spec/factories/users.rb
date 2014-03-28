FactoryGirl.define do
  factory :user, aliases: [:member] do
    github_handle { Faker::Name.name.underscore }
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    location { Faker::Address.city }
    country  { Faker::Address.country }
    bio      { Faker::Lorem.paragraph }
    homepage { Faker::Internet.http_url }

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
  end
end
