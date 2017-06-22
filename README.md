# Rails Girls Summer of Code Teams

[![Build Status](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams.png)](https://travis-ci.org/rails-girls-summer-of-code/rgsoc-teams)
[![Code Climate](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams.png)](https://codeclimate.com/github/rails-girls-summer-of-code/rgsoc-teams)
[![Dependency Status](https://gemnasium.com/rails-girls-summer-of-code/rgsoc-teams.svg)](https://gemnasium.com/rails-girls-summer-of-code/rgsoc-teams)
[![Stories in Ready](https://badge.waffle.io/rails-girls-summer-of-code/rgsoc-teams.png?label=In%20progress&title=In%20Progress)](https://waffle.io/rails-girls-summer-of-code/rgsoc-teams)

**Looking for your help!**

For Rails Girls Summer of Code building an app that
aggregates daily status updates, commit activity, GitHub issues, and other
things into an activity stream. The app also supports coaches and organizers
in centralizing the information they need to have to help keep RGSoC 
running along smoothly. 

Main goals are:

* make it easy to get an overview of activity/progress for each of the teams 
for supervision:
* make it easy for interested remote coaches to find opportunities to give 
support/help
* keep administrative information and processes in one place
* display to the world how much amazing stuff is happening

We are planning to require teams to keep a daily log of short updates about
their work. Our idea is to allow any sort of blog type tool for that (maybe
recommend a few) and aggregate things through RSS in a central app. This app
could then act as a webhook target for GitHub events.

We're really excited at how much this app has grown and developed, and are really 
grateful for all of the community help along the way. There's still plenty to do 
here - and we'd love to have your contributions! Hop on over to the 
[issues](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues) 
and have a look around, or open up a 
[new issue](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues/new).

Features:

* Users can sign in through GitHub Oauth
* Users can create and update teams (assuming they have the 
right access rights)
* Teams have members (students, coaches, mentors aka project maintainers),
 GitHub repositories, a log URL

* RSS feeds are fetched from all teams' logs regularly and aggregated
* There is a webhook endpoint for GitHub events that aggregates 
information about issues, pull requests and such

* Organizers can process new projects for submission, review new teams 
for selection, keep track of information on conferences for students

Contribution requirements:

* Keep it simple, so Rails Girls students can get involved, too
* By contributing, you agree to adhere to our 
[Code of Conduct](https://github.com/rails-girls-summer-of-code/rgsoc-teams/blob/master/CODE_OF_CONDUCT.md)

## System Requirements

In order to run the teams application locally so you can contribute, 
you will need to have the following dependencies already installed. 
Please see the [wiki](https://github.com/rails-girls-summer-of-code/rgsoc-teams/wiki) 
for more info on installing these requirements. 

* PostgreSQL 9.3 or newer
* Ruby 2.4.1

Instructions are given for Ubuntu or macOS. If you use macOS, we also 
strongly recommending installing/using [Homebrew](https://brew.sh/) for 
managing dependencies. 

# Contributing

Thanks so much for your contribution! To get setup to develop the RGSoC 
teams app, please follow the steps below. Here's some handy links within 
this section of the README:
 * [**Quick Start**](#quick-start) - gives a high-level overview 
of the required steps
 * [**Detailed Instructions**](#detailed-instructions) - gives 
this same information, but includes more notes about the individual 
commands and prompts to expect 
* [**Optional Configs**](#optional-configs) - gives instructions for
setting up other tools, such as Google Places API and Mailtrap which 
may be helpful 

### Quick Start
0. [Setup System Requirements](#setup-system-requirements)
1. [Configure Database](#configure-database) - Create a postgres user with superuser rights called `rgsoc` 
with password `rgsoc`. Setup your `config/database.yml` per the example:
`config/database.yml.example`
2. [Other dependencies & Sample Data](#other-dependencies--sample-data) - install with bundler, configure other services
3. [Run the app](#run-the-app) - run your rails server and console. The application will 
launch at [`http://localhost:3000/`](http://localhost:3000/).

## Detailed Instructions

### 0. Setup System Requirements

**Setup on Ubuntu**
```bash
# Install required packages
$ sudo apt-get install postgresql libpq-dev libcurl3 libcurl3-gnutls libcurl4-openssl-dev postgresql-contrib-9.3
```
**Setup on OS X**
```bash
# Install required packages
$ brew install ruby
$ gem install bundler
$ brew install postgres
```

#### 1. Configure Database

1. Create your database (if you have a new install of postgres)
2. Start server

```bash
# Create database user rgsoc with password rgsoc
$ sudo -u postgres createuser -P -s rgsoc
Enter password for new role: rgsoc
Enter it again: rgsoc
```
3. Copy `config/database.yml.example` to `config/database.yml`. Then make sure you
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

#### 2. Other Dependencies & Sample Data

**Install Project Dependencies & Setup Sample Data**
1. All project dependencies are managed with bundler:

```bash
bundle install
```

2. Also, a rake task can be used to initalize data into the `rgsoc` database:
```bash
bundle exec rake db:drop db:setup
```

_Note for OS X:_ There may be a bug on OS X which requires 64bit mode for `bundle install`.
If you find this bug, try:

```bash
ARCHFLAGS="-arch x86_64" bundle install
```
**Other Dependencies**
_Note:_If you configure any of these optional dependencies, it is important to
 run the `foreman run` command before any command in this probject.

**_Mailtrap (optional)_**

To avoid accidentally sending out mails to real addresses we suggest
[Mailtrap](https://mailtrap.io).
You can create a free account there with an inbox to 'trap' emails sent from
your development environment.

Copy the `.env-example` to `.env` and replace `InboxUsername` and
`InboxPassword` with your own username and password from your mailtrap
inbox.

*Note:* In case you did everything described above and your Mailtrap still 
doesn't work, it might happen because the `.env` doesn't set the `InboxUsername` 
and `InboxPassword` environment variables. To fix it, execute 
`export MAILTRAP_USER='your_user_code'` and 
`export MAILTRAP_PASSWORD='your_pass_code'` in your terminal and then run the 
server as usual: `./bin/rails server`. The user and pass codes should be 
copied from your Mailtrap account (they look like this: `94a5agb6c4c47d`).

**_Google Places API (optional)_**

To avoid accidentally exceeding the rate limit on 
[Google's Places API][google-places] (e.g. when heavily testing 
city-autocomplete fields) and thus blocking its usage for other RGSoC sites 
and devs:

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

#### 3. Run the App
To run the application use:
```bash
rails server
```
and
```bash
rails console
```
If you setup any optional dependencies (Mailtrap, Google Places API), 
preappend project commands with `foreman run`:
```bash
foreman rails server
```
and
```bash
foreman rails console
```

The project will run at [http://localhost:3000](http://localhost:3000)

**For first-time setup after initializing your database, add yourself as an 
`organizer` in your local app: 

In Rails Console:
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

Once you are an `organizer`, you can add a season and switch between season's phases at
http://localhost:3000/orga/seasons in your browser.

While in development, you are also able to impersonate other users to easily test the system
as someone else. Go to http://localhost:3000/users while logged in to do that.

---

You are good to go now. Happy coding!

--

## Testing

Please write relevant tests as you code, and test locally before opening a pull request. 
Thank you! 

To test, use a rake task as follows:

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

This app uses [camo](https://github.com/atmos/camo) to proxy insecure images in activity logs
when `CAMO_HOST` and `CAMO_KEY` environment variables are set.

### Cron jobs

Set up the Heroku scheduler to run these tasks:

* `rake activity:update`  every 10 min
* `rake teams:notify_missing_log_updates` once per day as close to midnight as possible (currently 23:30 UTC)
