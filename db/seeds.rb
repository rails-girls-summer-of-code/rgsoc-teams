FactoryGirl.create_list(:student, 12)
FactoryGirl.create_list(:coach, 3)
FactoryGirl.create :mentor
FactoryGirl.create :supervisor
FactoryGirl.create_list(:organizer, 2)
FactoryGirl.create_list(:user, 6) #for use cases where user has no role yet

FactoryGirl.create_list(:job_offer, 5, :with_details)