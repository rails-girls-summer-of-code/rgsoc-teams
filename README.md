# Rails Girls Summer of Code Teams
[![Build Status](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams.svg?branch=master)](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams)
[![Maintainability](https://api.codeclimate.com/v1/badges/d90e0f308dca4ed4cb90/maintainability)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/96b6902be01f7da6874b/test_coverage)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams/test_coverage)

**Looking for your help!**

For RGSoC we are building an app that aggregates daily status updates, commit activity and other sources into an activity stream.

Main goals are:

* make it easy to get an overview of each team's activity/progress for supervision
* make it easy for people interested in coaching to find opportunities to give support/help
* display to the world how much amazing stuff is happening

Features:

* Users can sign in through GitHub OAuth
* Students can create teams and apply for the program
* Teams can organize their members (students, coaches, mentors aka project maintainers)
* RSS feeds are fetched from all teams' logs regularly and aggregated
* Organizers can process new projects for submission, review new teams for selection, keep track of information on conferences for students

We're really excited at how much this app has grown and developed, and are really
grateful for all of the community help along the way. There's still plenty to do
here - and we'd love to have your contributions! Hop on over to the
[issues](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues)
and have a look 👀.

Requirements:

* Keep it simple to lower the barrier for RGSoC students to contribute too
* By contributing, you agree to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md)
* Make sure to check our [Contribution Guide](CONTRIBUTING.md)

## Getting Started

In order to contribute, you need to run the Teams App locally on your computer. For setting it up, you'll need to have some tools installed on your system:

* PostgreSQL 9.5 or newer
* Ruby 2.5.1
* [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/)

The following section will guide you step by step through the setup and installation process on Linux 🐧 and macOS 🍏

### 1. Installation

#### Setup on Ubuntu 🐧
```bash
# Install required packages
sudo apt-get install postgresql libpq-dev libcurl3 libcurl3-gnutls libcurl4-openssl-dev postgresql-contrib-9.5 chromium-chromedriver

# Install bundler
gem install bundler

# Create database user rgsoc with password rgsoc
sudo -u postgres createuser -P -s rgsoc
# Enter password for new role: rgsoc
# Enter it again: rgsoc
```

#### Setup on macOS 🍏
```bash
# Install required packages
brew install ruby postgres
# Make sure to follow the instructions printed on the screen for postgres

# Install chromedriver
brew tap caskroom/cask
brew cask install chromedriver

# Install bundler
gem install bundler

# Update postgres then start postgres to avoid any conflicts while creating the pg user 
brew postgresql-upgrade-database

# Start postgres 
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

# Create database user rgsoc with password rgsoc
createuser -P -s rgsoc
# Enter password for new role: rgsoc
# Enter it again: rgsoc
```

💁 Ran into problems so far with the setup? Check our **[Troubleshooting Guide](TROUBLESHOOTING.md)**.

### 2. Project setup

Once you have you system ready, we need to setup the database and the Rails app. The steps are the same for 🐧 and 🍏.

Copy `config/database.yml.example` file to `config/database.yml`:

    cp config/database.yml.example config/database.yml

Then modify the new `database.yml` file to your needs. Add username and password in the development and test sections:

    development:
      adapter: postgresql
      database: rgsocteams_development
      host: localhost
      username: rgsoc
      password: rgsoc

    test:
      adapter: postgresql
      database: rgsocteams_test
      host: localhost
      username: rgsoc
      password: rgsoc

Then back in the root directory of the project, install all project dependencies with bundler:

    bundle install

Once this is done, setup the database and fill it with some initial data:

    bundle exec rails db:setup

💁 Want more? Check the **[Optional Setup](#optional-setup)** section for setting up some additional tooling 👇

### 3. Run the App

Start the Rails server:

    bundle exec rails server

The project will run at **http://localhost:3000**

💁 All set? Check the **[Quick Start](#quick-start)** section for the first steps in the project 👇

#### Quick Start 

Some tips for your first interactions with the Teams App. For this, make sure you have the server running and the app open in your browser 🖥.

    http://localhost:3000

To access all functionality of the app, add yourself as an organizer. For this, first start an interactive Rails console in a separate terminal (window/tab) 📟:

    bundle exec rails console

1. In the browser 🖥: log in with your Github account
1. In the console 📟
    ```ruby
    user = User.last
    user.roles.create(name: 'organizer')

    # alternative: find your user, e.g. by your Github handle
    user = User.find_by(github_handle: <your-github-handle-here>)

    # You can assign yourself other roles the same way.
    # If you've assigned yourself student AND organizer roles however,
    # this may lead to undesired behavior of the app. Best remove the
    # student role again.
    ```
1. Refresh the browser 🖥: you should see links to orga pages now

Once you're an `organizer`, you can:
- add a season and switch between the phases of a season: http://localhost:3000/organizers/seasons
- impersonate other users to test the system from a different perspective: http://localhost:3000/community _(this only works in development mode)_

💁  you are good to go now. Happy coding!

## Optional Setup

### Google Places API

To avoid accidentally exceeding the rate limit on [Google's Places API](https://developers.google.com/places) (e.g. when heavily testing city-autocomplete fields) and thus blocking its usage for other RGSoC sites and devs:

Get your own [API key](https://developers.google.com/places/javascript/), and set the `GOOGLE_MAPS_API_KEY` environment variable *(or simply override the key in `config/initializers/google_maps.rb`)*:

    export GOOGLE_MAPS_API_KEY=<your-api-key>

## Testing

Please write relevant tests as you code, and test locally before opening a pull request. Thank you!

    bundle exec rake spec

You can optionally create a test-coverage report in `coverage/*` like so:

    COVERAGE=yes bundle exec rake spec

### Feature Tests

Feature tests run in headless Chrome. For local debugging, you can run them in a normal window by tagging the examples with `driver: :selenium_chrome`, like so:

```ruby
it 'is an interesting example', driver: :selenium_chrome do
  visit some_path

  # you can e.g. interrupt here
  binding.pry
  # now you can switch to Chrome and inspect things there

  # etc.
end
```

### Code Analysis 

You can run automatic code analyzers to check if your code complies to the project's guidelines and general best practice.

For Ruby code:

    bundle exec rubocop

For JS code: _(you need to install [`jshint`](http://jshint.com/install/) first)_

    jshint app/assets/javascript

## Deployment

The staging app lives at http://rgsoc-teams-staging.herokuapp.com. The production app is at http://teams.railsgirlssummerofcode.org.

    [remote "staging"]
            url = git@heroku.com:rgsoc-teams-staging.git
            fetch = +refs/heads/*:refs/remotes/staging/*
    [remote "production"]
            url = git@heroku.com:rgsoc-teams-production.git
            fetch = +refs/heads/*:refs/remotes/production/*

Append `-r staging` or `-r production` to any `heroku` command in order to specify the app.

### Cron jobs

The Heroku scheduler is set to run these tasks:

* `rake activity:update`  every 10 min

### Camo

Both apps on Heroku use [camo](https://github.com/atmos/camo) to proxy insecure images in activity logs. For this to work, the `CAMO_HOST` and `CAMO_KEY` environment variables need to be set in Heroku's configuration for the app.
