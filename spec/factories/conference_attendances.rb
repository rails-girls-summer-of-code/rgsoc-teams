FactoryGirl.define do
  factory :conference_attendance do
    attendance false
    orga_comment "MyText"
    team
    conference
  end
end
