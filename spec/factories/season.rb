FactoryGirl.define do
  factory :season do
    name { Date.today.year.to_s }
  end
end
