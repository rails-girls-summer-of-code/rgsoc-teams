FactoryGirl.define do
  factory :company do
    sequence(:name) { |i| "#{Faker::Company.name} & daugthers #{i}" }
    association :owner, factory: :user
  end
end
