FactoryBot.define do
  factory :mailing do
    subject { FFaker::CheesyLingo.sentence } # rubocop:disable RSpec/EmptyLineAfterSubject
    to 'students'
  end
end
