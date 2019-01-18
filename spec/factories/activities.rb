FactoryBot.define do
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
      title { FFaker::CheesyLingo.sentence }
      content { FFaker::CheesyLingo.paragraph }
    end
  end
end
