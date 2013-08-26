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

ActiveRecord::Schema.define(version: 0) do

  create_table "crew", id: false, force: true do |t|
    t.string "program", limit: 14, null: false
    t.string "name",    limit: 41, null: false
    t.string "role",    limit: 30
  end

  add_index "crew", ["name"], name: "name", using: :btree
  add_index "crew", ["program"], name: "program", using: :btree

  create_table "genre", id: false, force: true do |t|
    t.string  "program",   limit: 14, null: false
    t.string  "genre",     limit: 30, null: false
    t.integer "relevance",            null: false
  end

  add_index "genre", ["genre"], name: "genre", using: :btree
  add_index "genre", ["program"], name: "program", using: :btree

  create_table "lineup", force: true do |t|
    t.string "name",       limit: 42, null: false
    t.string "location",   limit: 28, null: false
    t.string "device",     limit: 30
    t.string "type",       limit: 20, null: false
    t.string "postalCode", limit: 6
  end

  create_table "map", id: false, force: true do |t|
    t.string   "lineup",       limit: 12, null: false
    t.integer  "station",                 null: false
    t.integer  "channel"
    t.integer  "channelMinor"
    t.datetime "validFrom"
    t.datetime "validTo"
    t.datetime "onAirFrom"
    t.datetime "onAirTo"
  end

  add_index "map", ["station"], name: "station", using: :btree

  create_table "program", force: true do |t|
    t.string  "series",                  limit: 10
    t.string  "title",                   limit: 120, null: false
    t.string  "subtitle",                limit: 150
    t.string  "description"
    t.string  "mpaaRating",              limit: 5
    t.string  "starRating",              limit: 5
    t.integer "runTime"
    t.integer "year"
    t.string  "showType",                limit: 30
    t.string  "colorCode",               limit: 20
    t.date    "originalAirDate"
    t.string  "syndicatedEpisodeNumber", limit: 20
    t.string  "advisories",              limit: 190
  end

  add_index "program", ["title", "subtitle", "description"], name: "text", type: :fulltext
  add_index "program", ["title"], name: "title", using: :btree
  add_index "program", ["year"], name: "year", using: :btree

  create_table "schedule", id: false, force: true do |t|
    t.string   "program",        limit: 14, null: false
    t.integer  "station",                   null: false
    t.datetime "time",                      null: false
    t.integer  "duration",                  null: false
    t.integer  "startDate",                 null: false
    t.integer  "startTime",                 null: false
    t.integer  "weekday",                   null: false
    t.boolean  "new"
    t.boolean  "stereo"
    t.boolean  "subtitled"
    t.boolean  "hdtv"
    t.boolean  "closeCaptioned"
    t.boolean  "ei"
    t.string   "tvRating",       limit: 5
    t.string   "dolby",          limit: 30
    t.integer  "partNumber"
    t.integer  "partTotal"
  end

  add_index "schedule", ["program", "station"], name: "program", using: :btree
  add_index "schedule", ["startDate"], name: "startDate", using: :btree
  add_index "schedule", ["startTime"], name: "startTime", using: :btree
  add_index "schedule", ["weekday"], name: "weekday", using: :btree

  create_table "station", force: true do |t|
    t.string  "callSign",         limit: 10, null: false
    t.string  "name",             limit: 40, null: false
    t.string  "affiliate",        limit: 25
    t.integer "fccChannelNumber"
  end

end
