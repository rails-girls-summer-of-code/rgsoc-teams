# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150409231057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.integer  "team_id"
    t.string   "kind"
    t.string   "guid"
    t.string   "author"
    t.string   "title"
    t.text     "content"
    t.string   "source_url"
    t.datetime "published_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "img_url"
  end

  create_table "application_drafts", force: true do |t|
    t.text     "coaches_contact_info"
    t.text     "coaches_hours_per_week"
    t.text     "coaches_why_team_successful"
    t.text     "project_name"
    t.text     "project_url"
    t.text     "misc_info"
    t.text     "heard_about_it"
    t.string   "signed_off_by"
    t.datetime "signed_off_at"
    t.integer  "team_id"
    t.integer  "season_id"
    t.boolean  "voluntary"
    t.integer  "voluntary_hours_per_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "applied_at"
    t.integer  "updater_id"
    t.text     "state",                       default: "draft", null: false
    t.integer  "position"
    t.text     "project_plan"
  end

  add_index "application_drafts", ["season_id"], name: "index_application_drafts_on_season_id", using: :btree
  add_index "application_drafts", ["team_id"], name: "index_application_drafts_on_team_id", using: :btree

  create_table "applications", force: true do |t|
    t.hstore   "application_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender_identification_student"
    t.string   "gender_identification_pair"
    t.text     "misc_info"
    t.string   "sponsor_pick"
    t.integer  "project_visibility"
    t.string   "project_name"
    t.boolean  "hidden"
    t.text     "flags",                         default: [], array: true
    t.string   "country"
    t.string   "city"
    t.string   "coaching_company"
    t.integer  "form_application_id"
    t.integer  "season_id"
    t.integer  "team_id"
    t.integer  "application_draft_id"
    t.json     "team_snapshot"
  end

  add_index "applications", ["application_draft_id"], name: "index_applications_on_application_draft_id", using: :btree
  add_index "applications", ["season_id"], name: "index_applications_on_season_id", using: :btree
  add_index "applications", ["team_id"], name: "index_applications_on_team_id", using: :btree

  create_table "attendances", force: true do |t|
    t.integer  "conference_id"
    t.integer  "user_id"
    t.boolean  "confirmed"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "comments", force: true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "application_id"
  end

  create_table "conferences", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "twitter"
    t.string   "url"
    t.date     "starts_on"
    t.date     "ends_on"
    t.integer  "tickets"
    t.integer  "accomodation"
    t.integer  "flights"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_offers", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.string   "company_name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "location"
    t.string   "duration"
    t.boolean  "paid"
    t.boolean  "rgsoc_only"
    t.text     "misc_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailings", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "cc"
    t.string   "bcc"
    t.string   "subject"
    t.text     "body"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "application_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "pick"
  end

  create_table "roles", force: true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: true do |t|
    t.date     "starts_at"
    t.date     "ends_at"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "applications_open_at"
    t.datetime "applications_close_at"
  end

  create_table "sources", force: true do |t|
    t.string   "url"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "kind"
    t.string   "feed_url"
    t.string   "title"
  end

  create_table "submissions", force: true do |t|
    t.integer  "mailing_id"
    t.string   "to"
    t.text     "error"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "log_url"
    t.text     "description"
    t.integer  "number"
    t.string   "kind"
    t.string   "twitter_handle"
    t.string   "github_handle"
    t.date     "starts_on"
    t.date     "finishes_on"
    t.string   "post_info"
    t.integer  "event_id"
    t.date     "last_checked_at"
    t.integer  "last_checked_by"
    t.integer  "season_id"
    t.boolean  "invisible",       default: false
  end

  add_index "teams", ["season_id"], name: "index_teams_on_season_id", using: :btree

  create_table "users", force: true do |t|
    t.integer  "github_id"
    t.string   "github_handle"
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.text     "bio"
    t.string   "homepage"
    t.string   "avatar_url"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "team_id"
    t.string   "twitter_handle"
    t.string   "irc_handle"
    t.string   "tshirt_size"
    t.text     "banking_info"
    t.text     "postal_address"
    t.string   "timezone"
    t.string   "interested_in",                     default: [],                 array: true
    t.boolean  "hide_email"
    t.boolean  "is_company",                        default: false
    t.string   "company_name"
    t.text     "company_info"
    t.string   "country"
    t.boolean  "application_voluntary"
    t.integer  "application_coding_level"
    t.text     "application_gender_identification"
    t.text     "application_learning_period"
    t.text     "application_minimum_money"
    t.text     "application_about"
    t.text     "application_code_samples"
    t.text     "application_community_engagement"
    t.text     "application_learning_history"
    t.text     "application_location"
    t.text     "application_skills"
    t.text     "application_motivation"
  end

end
