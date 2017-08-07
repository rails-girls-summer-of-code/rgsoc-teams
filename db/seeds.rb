# Teams
FactoryGirl.create_list(:team, 5, :in_current_season, kind: "sponsored")
FactoryGirl.create(:team, :in_current_season, kind: "voluntary")
FactoryGirl.create(:team, :in_current_season) #not accepted

FactoryGirl.create(:team, :last_season, kind: "sponsored")
FactoryGirl.create(:team, :last_season, kind: "voluntary")

# Users with different roles
FactoryGirl.create_list(:team, 5, :in_current_season, kind: "sponsored")
FactoryGirl.create(:team, :in_current_season, kind: "voluntary")

FactoryGirl.create_list(:student, 12)
FactoryGirl.create_list(:coach, 3)
FactoryGirl.create_list(:organizer, 2)
FactoryGirl.create(:mentor)
FactoryGirl.create(:supervisor)

# To explore use cases where user has no role yet
FactoryGirl.create_list(:user, 3)


# Status updates for different teams
5.times do
  FactoryGirl.create(:status_update, published_at: Time.now, team: Team.all.sample)
end

# Applications and their projects
FactoryGirl.create(:application_draft)
FactoryGirl.create(:application_draft, :appliable)

FactoryGirl.create(:project, :in_current_season) #proposed
FactoryGirl.create(:project, :accepted, :in_current_season)
FactoryGirl.create(:project, :rejected, :in_current_season)

# Conferences
6.times do
  random_date = rand(1.year).seconds.from_now
  FactoryGirl.create(:conference, :in_current_season,
    location: FFaker::Venue.name,
    region: ["Africa", "South America", "North America", "Europe", "Asia Pacific"].sample,
    starts_on: random_date,
    ends_on: random_date + rand(2.days),
    lightningtalkslots: rand < 0.5,
    tickets: [2,4,6].sample,
    accomodation: 2,
    flights: 0,
    round: [1,2].sample
  )
end
