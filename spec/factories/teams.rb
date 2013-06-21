FactoryGirl.define do
  factory :team do
    kind 'sponsored'
    projects 'Sinatra'
    sequence(:name) { |i| "#{i}-#{Faker::Lorem.word}" }
  end
end
