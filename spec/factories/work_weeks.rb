FactoryBot.define do
  factory :work_week do
    label                   { FFaker::Lorem.sentence }
    human_readable_label    { FFaker::Lorem.sentence }
  end

  factory :application_draft_work_week do
    association :work_week
    association :application_draft
  end
end
