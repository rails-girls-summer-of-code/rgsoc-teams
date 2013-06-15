FactoryGirl.define do
  factory :team do
    sequence(:name) { |i| "#{i}-#{Faker::Lorem.word}" }
  end
end
