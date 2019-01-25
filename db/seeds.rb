# NOTE: we do not want to send any email when seeding the database
ActionMailer::Base.perform_deliveries = false

# Teams
FactoryBot.create_list(:team, 5, :in_current_season, kind: "full_time")
FactoryBot.create(:team, :in_current_season, kind: "part_time")
FactoryBot.create(:team, :in_current_season) # not accepted

FactoryBot.create(:team, :last_season, kind: "sponsored")
FactoryBot.create(:team, :last_season, kind: "voluntary")

# Users with different roles
FactoryBot.create_list(:student, 6)
FactoryBot.create(:student, :unconfirmed)

FactoryBot.create_list(:coach, 3)
FactoryBot.create(:coach, :unconfirmed)
FactoryBot.create(:coach, :unconfirmed, github_id: nil)

FactoryBot.create_list(:organizer, 2)
FactoryBot.create(:mentor)
FactoryBot.create(:supervisor)

# To explore use cases where user has no role yet
FactoryBot.create_list(:user, 3)
FactoryBot.create(:user, :unconfirmed)
FactoryBot.create(:user, unconfirmed_email: "newer_email@example.com")

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
    ends_on: random_date + rand(2.days)
  )
end
