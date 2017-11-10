FactoryBot.define do
  factory :comment do
    user
    text { FFaker::CheesyLingo.paragraph }

    factory :team_comment do
      association :commentable, factory: :team
    end

    factory :application_comment do
      association :commentable, factory: :application
    end
  end
end
