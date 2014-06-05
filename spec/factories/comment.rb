FactoryGirl.define do
  factory :comment do
    user
    text { Faker::Lorem.paragraph }

    factory :team_comment do
      team
    end

    factory :application_comment do
      application
    end
  end
end
