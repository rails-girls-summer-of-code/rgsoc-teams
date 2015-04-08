FactoryGirl.define do
  factory :job_offer do
    title         { FFaker::Lorem.sentence(5) }
    description   { FFaker::Lorem.paragraph }
    company_name  { FFaker::Company.name }
    contact_email { FFaker::Internet.email }
    location      { [ FFaker::Address.city, FFaker::Address.country ].join(', ') }
  end
end
