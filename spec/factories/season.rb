FactoryBot.define do
  factory :season do
    sequence(:name, '2000')
  end

  trait :past do
    name '2010'
  end
end
