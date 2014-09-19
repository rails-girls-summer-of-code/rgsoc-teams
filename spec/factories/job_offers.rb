FactoryGirl.define do
  factory :job_offer do
    title         { Faker::Lorem.sentence(5) }
    description   { Faker::Lorem.paragraph }
    company_name  { Faker::Company.name }
    contact_email { Faker::Internet.email }
    location      { [ Faker::Address.city, Faker::Address.country ].join(', ') }
  end
end
