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

ActiveRecord::Schema.define(version: 20160225022434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "answer"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.date     "date_start"
    t.string   "genre"
    t.integer  "price"
    t.string   "site"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "date_end"
  end

  create_table "expenses", force: :cascade do |t|
    t.string   "textmsg"
    t.float    "cost"
    t.string   "date"
    t.string   "time"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id", using: :btree

  create_table "galleries", force: :cascade do |t|
    t.string   "url"
    t.string   "caption"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "galleries", ["event_id"], name: "index_galleries_on_event_id", using: :btree

  create_table "moneyexchanges", force: :cascade do |t|
    t.float    "money"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "question"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "questions", ["event_id"], name: "index_questions_on_event_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "old"
    t.string   "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "expenses", "users"
  add_foreign_key "galleries", "events"
  add_foreign_key "questions", "events"
  add_foreign_key "trips", "users"
end
