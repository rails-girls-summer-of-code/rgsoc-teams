FactoryGirl.create_list(:student, 7)
FactoryGirl.create_list(:coach, 3)
FactoryGirl.create :mentor
FactoryGirl.create :supervisor
FactoryGirl.create_list(:organizer, 2)

FactoryGirl.create_list(:job_offer, 5, :with_details)