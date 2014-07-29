# Rails Girl Summer of Code Teams

[![Build Status](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams.png)](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams)
[![Code Climate](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams.png)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams)

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

## System Requirements

* PostgreSQL 9.2 or newer
* Ruby 2.1.1

## Bootstrap

Copy `config/database.yml.example` to `config/database.yml`. Then make sure you
modify the settings so it could connect to your postgres server.

Then install all dependencies:

```bash
bundle install
bundle exec rake db:drop db:create db:migrate
```

### Mailtrap

    To avoid accidentally sending out mails to real addresses we user [Mailtrap](https://mailtrap.io).
Create an account and inbox there and add the username and password from to your environment.
Depending on your environment put the following lines in `.zshrc` (if you use ZSH) or `.bash_profile` (if you use BASH):

```
export MAILTRAP_USER=>>USERNAME<<
export MAILTRAP_PASSWORD=>>PASSWORD<<
```
_**Note:** Replace `>>USERNAME<<` & `>>PASSOWORD<<` according to the Mailtrap-Inbox._

## Testing

```bash
bundle exec rake spec
```

You can optionally create a test-coverage report in `coverage/*` like so:

```bash
COVERAGE=yes bundle exec rake spec
```

## Deployment

The staging app lives at http://rgsoc-teams-staging.herokuapp.com/users. The production app is
at http://teams.railsgirlssummerofcode.org.

```
[remote "staging"]
        url = git@heroku.com:rgsoc-teams-staging.git
        fetch = +refs/heads/*:refs/remotes/staging/*
[remote "production"]
        url = git@heroku.com:rgsoc-teams-production.git
        fetch = +refs/heads/*:refs/remotes/production/*
```

Append `-r staging` or `-r production` to any `heroku` command in order to specify the app.

### Cron job set up for activity:update

A scheduler should be set up to rake `activity:update` rake task every 10 min
