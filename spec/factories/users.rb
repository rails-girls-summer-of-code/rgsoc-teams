FactoryGirl.define do
  factory :user, aliases: [:member] do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    location { Faker::Address.country }
    bio      { Faker::Lorem.paragraph }
    homepage { Faker::Internet.http_url }
    role     { User::ROLES.sample }

    factory :coach do
      role 'coach'
    end

    factory :student do
      role 'student'
    end

    factory :mentor do
      role 'mentor'
    end
  end
end
