# Rails Girls Summer of Code Teams
[![Build Status](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams.svg?branch=master)](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams)
[![Code Climate](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams.svg)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams)
[![Dependency Status](https://gemnasium.com/badges/github.com/rails-girls-summer-of-code/rgsoc-teams.svg)](https://gemnasium.com/github.com/rails-girls-summer-of-code/rgsoc-teams)

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
* By contributing, you agree to adhere to our [Code of Conduct](https://github.com/rails-girls-summer-of-code/rgsoc-teams/blob/master/CODE_OF_CONDUCT.md)

## System Requirements

* PostgreSQL 9.5 or newer
* Ruby 2.4.2

### Setup on Ubuntu
```bash
# Install required packages
$ sudo apt-get install postgresql libpq-dev libcurl3 libcurl3-gnutls libcurl4-openssl-dev postgresql-contrib-9.5
# Create database user rgsoc with password rgsoc
$ sudo -u postgres createuser -P -s rgsoc
Enter password for new role: rgsoc
Enter it again: rgsoc
```

### Setup on OS X
```bash
# Install required packages
$ brew install ruby
$ gem install bundler
$ brew install postgres
# Make sure to follow the instructions printed on the screen for postgres

# Create database user rgsoc with password rgsoc
$ createuser -P -s rgsoc
Enter password for new role: rgsoc
Enter it again: rgsoc
```

## Bootstrap

Copy `config/database.yml.example` to `config/database.yml`. Then make sure you
modify the settings so it could connect to your postgres server.

Inside database.yml add username and password for development and test:

    development:
      adapter: postgresql
      database: rgsocteams_development
      host: localhost
      username: rgsoc
      password: rgsoc

Then install all dependencies:

    bundle install
    bundle exec rails db:setup

### Mailtrap (optional)

To avoid accidentally sending out mails to real addresses we suggest
[Mailtrap](https://mailtrap.io).
You can create a free account there with an inbox to 'trap' emails sent from
your development environment.

Copy the `.env-example` to `.env` and replace `InboxUsername` and
`InboxPassword` with your own username and password from your mailtrap
inbox.

Now when running the command `foreman` *before* any command in this project
directory the variables from `.env` will be loaded into the environment.

E.g. `foreman run rails server` or `foreman run rails console`.

**NOTE:** In case you did everything described above and your Mailtrap still doesn't work, it might happen because the `.env` doesn't set the `InboxUsername` and `InboxPassword` environment variables. To fix it, execute `export MAILTRAP_USER='your_user_code'` and `export MAILTRAP_PASSWORD='your_pass_code'` in your terminal and then run the server as usually: `./bin/rails server`. The user and pass codes should be copied from your Mailtrap account (they look like this: `94a5agb6c4c47d`).

### Google Places API (optional)

To avoid accidentally exceeding the rate limit on [Google's Places API][google-places] (e.g. when heavily testing city-autocomplete fields) and thus blocking its usage for other RGSoC sites and devs:

1. [Get your own key][google-places]

1. Copy the `.env-example` file to `.env` and replace `YourGoogleMapsAPIKey` with your key

1. Run the `foreman` command before any command
  ```sh
  # e.g.
  foreman run rails server
  # or
  foremand run rails console
  ```
[google-places]: https://developers.google.com/places/javascript/

## Quick Start 

### Beginner Friendly Tips for New Contributors

- After forking the repo, follow the steps described above under 'Bootstrap'. Mailtrap is optional.
- (Install and) connect to Postgres server 
- With everything properly installed, open the browser in development environment
- The app should be available, with the database loaded with fake data.
- To access all the functionality of the teams app, add yourself as an organizer.
    * In the browser: log in with your github account 
    * In Rails Console:
      ```
      user = User.last
      user.roles.create(name: "organizer")
      ```
      Instead of using the last created User, you can also search for a
      specific User with ```user = User.find_by(github_handle: "yourgithubhandle")```.

      You can assign yourself other roles in the same way as creating the
      organizer role. If however you assign yourself a student role AND another
      role, that may lead to unexpected behavior in the app. In that case,
      remove the student role. 
    * Refresh the browser and you should see links for organizers. 
- Once you are an `organizer`, you can add a season and switch between season's phases at
http://localhost:3000/orga/seasons in your browser.
- While in development, you are also able to impersonate other users to easily test the system
as someone else. Go to http://localhost:3000/users while logged in to do that.
- You are good to go now. Happy coding!

## Testing

    bundle exec rake spec

You can optionally create a test-coverage report in `coverage/*` like so:

    COVERAGE=yes bundle exec rake spec

### Code Analyzation

You can run automatic code analyzers to check if your code complies to the project's guidelines and general best practice.

For Ruby code:

    bundle exec rubocop

For Javascript code: _(you need to install [`jshint`](http://jshint.com/install/) first)_

    jshint app/assets/javascript

## Deployment

The staging app lives at http://rgsoc-teams-staging.herokuapp.com. The production app is
at http://teams.railsgirlssummerofcode.org.

    [remote "staging"]
            url = git@heroku.com:rgsoc-teams-staging.git
            fetch = +refs/heads/*:refs/remotes/staging/*
    [remote "production"]
            url = git@heroku.com:rgsoc-teams-production.git
            fetch = +refs/heads/*:refs/remotes/production/*

Append `-r staging` or `-r production` to any `heroku` command in order to specify the app.

This app uses [camo](https://github.com/atmos/camo) to proxy insecure images in activity logs
when `CAMO_HOST` and `CAMO_KEY` environment variables are set.

### Cron jobs

Set up the Heroku scheduler to run these tasks:

* `rake activity:update`  every 10 min
* `rake teams:notify_missing_log_updates` once per day as close to midnight as possible (currently 23:30 UTC)
