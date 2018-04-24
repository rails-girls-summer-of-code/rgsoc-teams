# Rails Girls Summer of Code Teams
[![Build Status](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams.svg?branch=master)](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams)
[![Maintainability](https://api.codeclimate.com/v1/badges/d90e0f308dca4ed4cb90/maintainability)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams/maintainability)
[![Dependency Status](https://gemnasium.com/badges/github.com/rails-girls-summer-of-code/rgsoc-teams.svg)](https://gemnasium.com/github.com/rails-girls-summer-of-code/rgsoc-teams)

**Looking for your help!**

For RSGoC we are building an app that aggregates daily status updates, commit activity and other sources into an activity stream.

Main goals are:

* make it easy to get an overview of each team's activity/progress for supervision
* make it easy for people interested in coaching to find opportunities to give support/help
* display to the world how much amazing stuff is happening

Features:

* Users can sign in through GitHub OAuth
* Students can create teams and apply for the program
* Mentors can submit their projects for the program
* Teams can organize their members (students, coaches, mentors aka project maintainers)
* RSS feeds are fetched from all teams' logs regularly and aggregated
* Organizers can process new projects for submission, review new teams for selection, keep track of information on conferences for students

We're really excited at how much this app has grown and developed, and are really
grateful for all of the community help along the way. There's still plenty to do
here - and we'd love to have your contributions! Hop on over to the
[issues](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues)
and have a look 👀.

Contribution Requirements:

* Keep it simple to lower the barrier for RGSoC students to contribute too
* By contributing, you agree to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md)
* Make sure to check our [Contribution Guide](CONTRIBUTING.md)

## Getting Started

In order to contribute, you need to run the Teams App locally on your computer. For setting it up, you'll need to have some tools installed on your system:

* PostgreSQL 9.5 or newer
* Ruby 2.5.1
* [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/)

The following section will guide you step by step through the setup and installation process on Linux 🐧 and macOS 🍏

### Installation

#### Setup on Ubuntu 🐧
```bash
# Install required packages
sudo apt-get install postgresql libpq-dev libcurl3 libcurl3-gnutls libcurl4-openssl-dev postgresql-contrib-9.5 chromium-chromedriver

# Create database user rgsoc with password rgsoc
sudo -u postgres createuser -P -s rgsoc
# Enter password for new role: rgsoc
# Enter it again: rgsoc
```

#### Setup on macOS
```bash
# Install required packages
$ brew install ruby postgres chromedriver
# Make sure to follow the instructions printed on the screen for postgres
$ gem install bundler

# Create database user rgsoc with password rgsoc
$ createuser -P -s rgsoc
Enter password for new role: rgsoc
Enter it again: rgsoc
```

💁 Ran into problems so far with the setup? Check our **[Troubleshooting Guide](TROUBLESHOOTING.md)**.

#### Database & project dependencies

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
http://localhost:3000/organizers/seasons in your browser.
- While in development, you are also able to impersonate other users to easily test the system
as someone else. Go to http://localhost:3000/users while logged in to do that.
- You are good to go now. Happy coding!

## Testing

    bundle exec rake spec

You can optionally create a test-coverage report in `coverage/*` like so:

    COVERAGE=yes bundle exec rake spec

Feature tests run in headless Chrome. For local debugging, you can run them in a normal window by tagging the examples with `driver: :selenium_chrome`, like so:

```ruby
it 'is an interesting example', driver: :selenium_chrome
  visit some_path

  # you can e.g. interrupt here
  binding.pry
  # now you can switch to Chrome and inspect things there

  # etc.
end
```

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
