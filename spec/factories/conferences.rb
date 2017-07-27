FactoryGirl.define do
  factory :conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    url { FFaker::Internet.http_url }
    starts_on { Time.utc(Date.today.year, 7, 7) }
    ends_on { Time.utc(Date.today.year, 7, 15) }
    city { FFaker::Address.city }
    country { FFaker::Address.country }
    region { 'Africa' }
    round 1

    trait :in_current_season do
      season { Season.current }
    end
  end
end
