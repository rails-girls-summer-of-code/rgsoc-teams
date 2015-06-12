FactoryGirl.define do

  factory :activity do
    team

    trait :feed_entry do
      kind 'feed_entry'
    end

    trait :mailing do
      kind 'mailing'
    end

    trait :published do
      published_at { 1.day.ago }
      guid { SecureRandom.uuid }
    end
  end

end
