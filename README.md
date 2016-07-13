# Rails Girls Summer of Code Teams

[![Build Status](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams.png)](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams)
[![Code Climate](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams.png)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams)
[![Dependency Status](https://gemnasium.com/rails-girls-summer-of-code/rgsoc-teams.svg)](https://gemnasium.com/rails-girls-summer-of-code/rgsoc-teams)
[![Stories in Ready](https://badge.waffle.io/rails-girls-summer-of-code/rgsoc-teams.png?label=In%20progress&title=In%20Progress)](https://waffle.io/rails-girls-summer-of-code/rgsoc-teams)

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

* PostgreSQL 9.3 or newer
* Ruby 2.3.1

### Setup on Ubuntu
```bash
# Install required packages
$ sudo apt-get install postgresql libpq-dev libcurl3 libcurl3-gnutls libcurl4-openssl-dev postgresql-contrib-9.3
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
```
development:
  adapter: postgresql
  database: rgsocteams_development
  host: localhost
  username: rgsoc
  password: rgsoc
```
Then install all dependencies:

```bash
bundle install
bundle exec rake db:drop db:setup
```

**Note for OS X:** There is a bug where on OS X you need to force 64bit mode for `bundle install`:

```bash
ARCHFLAGS="-arch x86_64" bundle install
```

Otherwise pg gem installation will fail.

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

## Quick Start 
###Beginner Friendly Tips for New Contributors
- After forking the repo, follow the steps described above under 'Bootstrap'. Mailtrap is optional.
- (Install and) connect to Postgres server 
- With everything properly installed, open the browser in development environment
- The app should be available, with the database loaded with fake data.
- To access all the functionality of the teams app, add yourself as an organizer.
    * In the browser: log in with your github account 
    * In Rails Console:
    ``` user = User.last``` #or ```user = User.find_by(github_handle: "yourgithubhandle") ```
    ``` user.roles.create(name: "organizer") ```
    You can assign yourself other roles in the same way. If however you assign
    yourself a student role AND another role, that may lead to unexpected behavior in the app. In that case, remove the student role.    
    - Refresh the browser to effectuate. You should see links for organizers. 
- Once you are an `organizer`, you can add a season and switch between season's phases at
http://localhost:3000/orga/seasons in your browser.
- You are good to go now. Happy coding!

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

### Cron jobs

Set up the Heroku scheduler to run these tasks:

* `rake activity:update`  every 10 min
* `rake teams:notify_missing_log_updates` once per day as close to midnight as possible (currently 23:30 UTC)
