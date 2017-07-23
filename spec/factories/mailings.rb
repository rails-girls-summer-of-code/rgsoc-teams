# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mailing do
    subject FFaker::CheesyLingo.sentence
    to 'students'
  end
end
