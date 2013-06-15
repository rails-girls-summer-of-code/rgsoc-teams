FactoryGirl.define do
  factory :repository do
    team
    url { Faker::Internet.http_url }
  end
end
