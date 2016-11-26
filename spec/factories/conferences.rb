FactoryGirl.define do
    factory :conference do
      name [FFaker::CheesyLingo.title, 'Conf'].join(' ')
      tickets 2
      starts_on { Time.utc(Date.today.year, 7, 7) }
      ends_on { Time.utc(Date.today.year, 7, 15) }
      round 1

    trait :in_current_season do
      season { Season.current }
    end
  end
end
