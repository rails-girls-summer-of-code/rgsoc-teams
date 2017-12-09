# Teams
FactoryBot.create_list(:team, 5, :in_current_season, kind: "sponsored")
FactoryBot.create(:team, :in_current_season, kind: "voluntary")
FactoryBot.create(:team, :in_current_season) # not accepted

FactoryBot.create(:team, :last_season, kind: "sponsored")
FactoryBot.create(:team, :last_season, kind: "voluntary")

# Users with different roles
FactoryBot.create_list(:student, 12)
FactoryBot.create_list(:coach, 3)
FactoryBot.create_list(:organizer, 2)
FactoryBot.create(:mentor)
FactoryBot.create(:supervisor)

# To explore use cases where user has no role yet
FactoryBot.create_list(:user, 3)

# Status updates for different teams
5.times do
  FactoryBot.create(:status_update, published_at: Time.now, team: Team.all.sample)
end

# Applications and their projects
FactoryBot.create(:application_draft)
FactoryBot.create(:application_draft, :appliable)

FactoryBot.create(:project, :in_current_season) # proposed
FactoryBot.create_list(:project, 3, :accepted, :in_current_season)
FactoryBot.create(:project, :rejected, :in_current_season)

# Conferences
6.times do
  random_date = rand(1.year).seconds.from_now
  FactoryBot.create(:conference, :in_current_season,
    location: FFaker::Venue.name,
    region: ["Africa", "South America", "North America", "Europe", "Asia Pacific"].sample,
    starts_on: random_date,
    ends_on: random_date + rand(2.days),
    lightningtalkslots: rand < 0.5,
    tickets: [2, 4, 6].sample,
    accomodation: 2,
    flights: 0,
    round: [1, 2].sample
  )
end
