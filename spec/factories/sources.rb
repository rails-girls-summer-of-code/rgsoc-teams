FactoryGirl.define do
  factory :source do
    team
    kind 'repository'
    url  { Faker::Internet.http_url }
  end
end
