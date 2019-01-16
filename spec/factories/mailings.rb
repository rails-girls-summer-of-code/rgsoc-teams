FactoryBot.define do
  factory :mailing do
    subject { FFaker::CheesyLingo.sentence }

    to 'students'
  end
end
