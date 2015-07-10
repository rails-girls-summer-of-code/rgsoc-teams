FactoryGirl.define do
  factory :job_offer do
    title         { FFaker::Job.title }
    description   { FFaker::HipsterIpsum.paragraph }
    company_name  { FFaker::Company.name }
    contact_email { FFaker::Internet.email }
    location      { [ FFaker::Address.city, FFaker::Address.country ].join(', ') }

    trait :with_details do
      contact_name  { FFaker::Name.name }
      duration      { "#{[3,6,12,24].sample} months" }
      misc_info     { FFaker::Company.bs.capitalize }
      paid          { FFaker::Boolean.random }
    end
  end
end