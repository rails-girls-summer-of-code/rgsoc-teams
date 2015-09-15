FactoryGirl.create_list(:student, 12)
FactoryGirl.create_list(:coach, 3)
FactoryGirl.create_list(:organizer, 2)
FactoryGirl.create(:mentor)
FactoryGirl.create(:supervisor)

# To explore use cases where user has no role yet
# NB These are not listed in the Community listing
FactoryGirl.create_list(:user, 6)

#sandbox for job offers
FactoryGirl.create_list(:job_offer, 5, :with_details)
