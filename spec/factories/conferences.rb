FactoryGirl.define do
  factory :conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    tickets 2
    starts_on '2017-01-01'
    ends_on '2017-02-02'
    round 1

    trait :in_current_season do
      season { Season.current }
    end

  end
end
