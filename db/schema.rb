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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130622142925) do

  create_table "activities", :force => true do |t|
    t.integer  "team_id"
    t.string   "kind"
    t.string   "guid"
    t.string   "author"
    t.string   "title"
    t.text     "content"
    t.string   "source_url"
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "roles", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sources", :force => true do |t|
    t.string   "url"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "kind"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "log_url"
    t.text     "description"
    t.integer  "number"
    t.string   "kind"
    t.string   "projects"
    t.string   "twitter_handle"
    t.string   "github_handle"
  end

  create_table "users", :force => true do |t|
    t.integer  "github_id"
    t.string   "github_handle"
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.text     "bio"
    t.string   "homepage"
    t.string   "avatar_url"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "team_id"
    t.string   "twitter_handle"
    t.string   "irc_handle"
  end

end
