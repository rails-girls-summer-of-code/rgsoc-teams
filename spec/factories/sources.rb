FactoryBot.define do
  factory :source do
    team
    kind 'repository'
    url  { FFaker::Internet.http_url }
  end
end
