# Rails Girl Summer of Code Teams

**Looking for your help!**

For Rails Girls Summer of Code we are planning to build a simple app that
aggregates daily status updates, commit activity, GitHub issues and other
things into an activity stream.

Main goals are:

* make it easy to get an overview of activity/progress for each of the teams for supervision
* make it easy for interested remote coaches to find opportunities to give support/help
* display to the world how much amazing stuff is happening

We are planning to require teams to keep a daily log of short updates about
their work. Our idea is to allow any sort of blog type tool for that (maybe
recommend a few) and aggregate things through RSS in a central app. This app
could then act as a webhook target for GitHub events.

Since we still are somewhat overwhelmed with the amount of work we'd like to
ask the community for help with this. The app would need to be available
(initial, basic version) on 1st of July, ideally a few days earlier.

Features:

* Users can sign in through GitHub Oauth
* They can create and update teams
* Teams have members (students, coaches, mentors aka project maintainers), GitHub repositories, a log URL

* RSS feeds are fetched from all teams' logs regularly and aggregated
* There is a webhook endpoint for GitHub events that aggregates information about issues, pull requests and such

Requirements:

* Keep it simple, so Rails Girls students can get involved, too

# System Requirements

* PostgreSQL 9.2 or newer
* Ruby 2.0.0

# Bootstrap

Copy `config/database.yml.example` to `config/database.yml`. Then make sure you
modify the settings so it could connect to your postgres server.

Then install all dependencies:

```bash
bundle install
bundle exec rake db:drop db:create db:migrate
```

# Testing

```bash
bundle exec rake spec
```