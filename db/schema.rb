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

ActiveRecord::Schema.define(version: 20160408184821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "kind",         limit: 255
    t.string   "guid",         limit: 255
    t.string   "author",       limit: 255
    t.string   "title",        limit: 255
    t.text     "content"
    t.string   "source_url",   limit: 255
    t.datetime "published_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "img_url",      limit: 255
  end

  create_table "application_drafts", force: :cascade do |t|
    t.text     "coaches_contact_info"
    t.text     "project_name"
    t.text     "project_url"
    t.text     "misc_info"
    t.text     "heard_about_it"
    t.datetime "signed_off_at"
    t.integer  "team_id"
    t.integer  "season_id"
    t.boolean  "voluntary"
    t.integer  "voluntary_hours_per_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "applied_at"
    t.integer  "updater_id"
    t.text     "state",                    default: "draft", null: false
    t.text     "project_plan"
    t.integer  "signed_off_by"
    t.integer  "project1_id"
    t.integer  "project2_id"
    t.text     "working_together"
    t.text     "why_selected_project"
  end

  add_index "application_drafts", ["project1_id"], name: "index_application_drafts_on_project1_id", using: :btree
  add_index "application_drafts", ["project2_id"], name: "index_application_drafts_on_project2_id", using: :btree
  add_index "application_drafts", ["season_id"], name: "index_application_drafts_on_season_id", using: :btree
  add_index "application_drafts", ["signed_off_by"], name: "index_application_drafts_on_signed_off_by", using: :btree
  add_index "application_drafts", ["team_id"], name: "index_application_drafts_on_team_id", using: :btree

  create_table "applications", force: :cascade do |t|
    t.hstore   "application_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender_identification_student", limit: 255
    t.string   "gender_identification_pair",    limit: 255
    t.text     "misc_info"
    t.string   "sponsor_pick",                  limit: 255
    t.integer  "project_visibility"
    t.string   "project_name",                  limit: 255
    t.boolean  "hidden"
    t.text     "flags",                                     default: [], array: true
    t.string   "country",                       limit: 255
    t.string   "city",                          limit: 255
    t.string   "coaching_company",              limit: 255
    t.integer  "form_application_id"
    t.integer  "season_id"
    t.integer  "team_id"
    t.integer  "application_draft_id"
    t.json     "team_snapshot"
    t.integer  "signed_off_by"
    t.datetime "signed_off_at"
  end

  add_index "applications", ["application_draft_id"], name: "index_applications_on_application_draft_id", using: :btree
  add_index "applications", ["season_id"], name: "index_applications_on_season_id", using: :btree
  add_index "applications", ["signed_off_by"], name: "index_applications_on_signed_off_by", using: :btree
  add_index "applications", ["team_id"], name: "index_applications_on_team_id", using: :btree

  create_table "attendances", force: :cascade do |t|
    t.integer  "conference_id"
    t.integer  "user_id"
    t.boolean  "confirmed"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "application_id"
    t.integer  "project_id"
  end

  add_index "comments", ["project_id"], name: "index_comments_on_project_id", using: :btree

  create_table "conferences", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "location",     limit: 255
    t.string   "twitter",      limit: 255
    t.string   "url",          limit: 255
    t.date     "starts_on"
    t.date     "ends_on"
    t.integer  "tickets"
    t.integer  "accomodation"
    t.integer  "flights"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "round",                    default: 1
  end

  create_table "mailings", force: :cascade do |t|
    t.string   "from",       limit: 255
    t.string   "to",         limit: 255
    t.string   "cc",         limit: 255
    t.string   "bcc",        limit: 255
    t.string   "subject",    limit: 255
    t.text     "body"
    t.datetime "sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "group",                  default: 0
    t.text     "seasons",                default: [],              array: true
  end

  create_table "notes", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submitter_id"
    t.integer  "season_id"
    t.string   "mentor_name"
    t.string   "mentor_github_handle"
    t.string   "mentor_email"
    t.string   "url"
    t.text     "description"
    t.text     "issues_and_features"
    t.boolean  "beginner_friendly"
    t.string   "aasm_state"
    t.text     "tags",                             default: [],    array: true
    t.string   "source_url"
    t.boolean  "comments_locked",                  default: false
    t.string   "code_of_conduct"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "application_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "pick"
    t.integer  "rateable_id"
    t.string   "rateable_type",  limit: 255
  end

  add_index "ratings", ["rateable_id", "rateable_type"], name: "index_ratings_on_rateable_id_and_rateable_type", using: :btree

  create_table "roles", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "name",               limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.text     "state",                          default: "pending", null: false
    t.string   "confirmation_token"
  end

  create_table "seasons", force: :cascade do |t|
    t.date     "starts_at"
    t.date     "ends_at"
    t.string   "name",                       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "applications_open_at"
    t.datetime "applications_close_at"
    t.datetime "acceptance_notification_at"
    t.datetime "project_proposals_open_at"
    t.datetime "project_proposals_close_at"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.integer  "team_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "kind",       limit: 255
    t.string   "feed_url",   limit: 255
    t.string   "title",      limit: 255
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "mailing_id"
    t.string   "to",         limit: 255
    t.text     "error"
    t.datetime "sent_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "log_url",            limit: 255
    t.text     "description"
    t.integer  "number"
    t.string   "kind",               limit: 255
    t.string   "twitter_handle",     limit: 255
    t.string   "github_handle",      limit: 255
    t.date     "starts_on"
    t.date     "finishes_on"
    t.string   "post_info",          limit: 255
    t.date     "last_checked_at"
    t.integer  "last_checked_by"
    t.integer  "season_id"
    t.boolean  "invisible",                      default: false
    t.integer  "applications_count",             default: 0,     null: false
    t.string   "project_name"
  end

  add_index "teams", ["applications_count"], name: "index_teams_on_applications_count", using: :btree
  add_index "teams", ["season_id"], name: "index_teams_on_season_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "github_id"
    t.string   "github_handle",                        limit: 255
    t.string   "name",                                 limit: 255
    t.string   "email",                                limit: 255
    t.string   "location",                             limit: 255
    t.text     "bio"
    t.string   "homepage",                             limit: 255
    t.string   "avatar_url",                           limit: 255
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.integer  "team_id"
    t.string   "twitter_handle",                       limit: 255
    t.string   "irc_handle",                           limit: 255
    t.string   "tshirt_size",                          limit: 255
    t.text     "banking_info"
    t.text     "postal_address"
    t.string   "timezone",                             limit: 255
    t.string   "interested_in",                        limit: 255, default: [],                 array: true
    t.boolean  "hide_email"
    t.boolean  "is_company",                                       default: false
    t.string   "company_name",                         limit: 255
    t.text     "company_info"
    t.string   "country",                              limit: 255
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
    t.text     "application_code_background"
    t.text     "application_age"
    t.text     "application_goals"
    t.text     "application_language_learning_period"
    t.string   "application_money"
  end

end
