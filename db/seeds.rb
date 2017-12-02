# Teams
create_list(:team, 5, :in_current_season, kind: "sponsored")
create(:team, :in_current_season, kind: "voluntary")
create(:team, :in_current_season) # not accepted

create(:team, :last_season, kind: "sponsored")
create(:team, :last_season, kind: "voluntary")

# Users with different roles
create_list(:student, 12)
create_list(:coach, 3)
create_list(:organizer, 2)
create(:mentor)
create(:supervisor)

# To explore use cases where user has no role yet
create_list(:user, 3)

# Status updates for different teams
5.times do
  create(:status_update, published_at: Time.now, team: Team.all.sample)
end

# Applications and their projects
create(:application_draft)
create(:application_draft, :appliable)

create(:project, :in_current_season) # proposed
create_list(:project, 3, :accepted, :in_current_season)
create(:project, :rejected, :in_current_season)

# Conferences
6.times do
  random_date = rand(1.year).seconds.from_now
  create(:conference, :in_current_season,
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
