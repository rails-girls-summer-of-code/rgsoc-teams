FactoryGirl.define do
  factory :source do
    team
    url { Faker::Internet.http_url }
  end
end
