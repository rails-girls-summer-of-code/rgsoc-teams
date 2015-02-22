FactoryGirl.define do
  factory :season do
    name { Date.today.year.to_s }
    starts_at { Time.utc(Date.today.year, 7, 1) }
    ends_at { Time.utc(Date.today.year, 9, 30) }
    applications_open_at { Time.utc(Date.today.year, 3, 1) }
    applications_close_at { Time.utc(Date.today.year, 3, 31) }
  end
end
