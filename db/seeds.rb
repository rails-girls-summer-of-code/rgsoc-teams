FactoryGirl.create_list(:team, 5, :current_season, kind: "sponsored")
FactoryGirl.create(:team, :current_season, kind: "voluntary")
FactoryGirl.create(:team, :last_season, kind: "sponsored")
FactoryGirl.create(:team, :last_season, kind: "voluntary")

FactoryGirl.create_list(:student, 12)
FactoryGirl.create_list(:coach, 3)
FactoryGirl.create_list(:organizer, 2)
FactoryGirl.create(:mentor)
FactoryGirl.create(:supervisor)

# To explore use cases where user has no role yet
FactoryGirl.create_list(:user, 3)

#Create status updates for different teams
5.times do
  FactoryGirl.create(:status_update, published_at: Time.now, team: Team.all.sample)
end


FactoryGirl.create(:application_draft)
FactoryGirl.create(:application_draft, :appliable)

FactoryGirl.create(:project, :current) #proposed
FactoryGirl.create(:project, :accepted, :current)
FactoryGirl.create(:project, :rejected, :current)
