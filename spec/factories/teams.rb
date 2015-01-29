FactoryGirl.define do
  factory :team do
    kind 'sponsored'
    sequence(:name) { |i| "#{i}-#{Faker::Lorem.word}" }
  end

  trait :helpdesk do
    name 'helpdesk'
  end

  trait :supervise do
    name 'supervise'
  end
  
end
