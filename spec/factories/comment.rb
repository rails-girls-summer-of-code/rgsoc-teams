FactoryGirl.define do
  factory :comment do
    user
    text { FFaker::CheesyLingo.paragraph }

    factory :team_comment do
      commentable { create :team }
    end

    factory :application_comment do
      commentable { create :application }
    end
  end
end
