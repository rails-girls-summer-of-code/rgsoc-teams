FactoryGirl.define do
  factory :team do
    kind 'sponsored'
    projects 'Sinatra'
    sequence(:name) { |i| "#{i}-#{Faker::Lorem.word}" }
  end

  trait :helpdesk do
    name 'helpdesk'
  end

  trait :supervise do
    name 'supervise'
  end
  
end
