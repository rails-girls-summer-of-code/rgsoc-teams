FactoryGirl.define do

  factory :activity do
    team

    trait :feed_entry do
      kind 'feed_entry'
      source_url { FFaker::Internet.http_url }
    end

    trait :mailing do
      kind 'mailing'
    end

    trait :published do
      published_at { 1.day.ago }
      guid { SecureRandom.uuid }
    end

    factory :status_update do
      kind 'status_update'
      title { FFaker::Lorem.sentence(5) }
      content { FFaker::Lorem.paragraph }
    end

  end

end
