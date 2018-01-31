FactoryBot.define do
  factory :work_schedule do
    label                   { FFaker::Lorem.sentence }
    human_readable_label    { FFaker::Lorem.sentence }
  end

  factory :application_draft_work_schedule do
    association :work_schedule
    association :application_draft
  end
end
