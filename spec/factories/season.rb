FactoryBot.define do
  factory :season do
    sequence(:name, '2030')
  end

  trait :past do
    name '1999'
  end
end
