FactoryBot.define do
  factory :conference, class: Conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    url { FFaker::Internet.http_url }
    starts_on { Time.utc(Date.today.year, 7, 7) }
    ends_on { Time.utc(Date.today.year, 7, 15) }
    city { FFaker::Address.city }
    country { FFaker::Address.country }
    region 'Africa'

    trait :in_current_season do
      season { Season.current }
    end
  end

  factory :conference_europe, class: Conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    url { FFaker::Internet.http_url }
    starts_on { Time.utc(Date.today.year, 8, 8) }
    ends_on { Time.utc(Date.today.year, 8, 16) }
    city { FFaker::Address.city }
    country { FFaker::Address.country }
    region 'Europe'

    trait :in_current_season do
      season { Season.current }
    end
  end

  factory :conference_na, class: Conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    url { FFaker::Internet.http_url }
    starts_on { Time.utc(Date.today.year, 9, 9) }
    ends_on { Time.utc(Date.today.year, 9, 17) }
    city { FFaker::Address.city }
    country { FFaker::Address.country }
    region 'North America'

    trait :in_current_season do
      season { Season.current }
    end
  end
end
