FactoryGirl.define do
  factory :respository do
    url { Faker::Internet.http_url }
  end
end
