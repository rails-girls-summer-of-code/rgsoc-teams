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

* PostgreSQL 9.3 or newer
* Ruby 2.2.2 

## Bootstrap

Copy `config/database.yml.example` to `config/database.yml`. Then make sure you
modify the settings so it could connect to your postgres server.

Then install all dependencies:

```bash
bundle install
bundle exec rake db:drop db:create db:migrate
```

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
- Once you are an `organizer`, you can change the season from open to close and vice versa at http://localhost:3000/orga/seasons in your browser. 
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

### Cron job set up for activity:update

A scheduler should be set up to rake `activity:update` rake task every 10 min
