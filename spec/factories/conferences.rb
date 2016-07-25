FactoryGirl.define do
  factory :conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    tickets 2

    trait :in_current_season do
      season { Season.current }
    end

  end
end
