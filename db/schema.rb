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

ActiveRecord::Schema.define(version: 2018_11_18_220551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "joinrequests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "team_id"], name: "index_joinrequests_on_user_id_and_team_id", unique: true
  end

  create_table "legacy_sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_legacy_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_legacy_sessions_on_updated_at"
  end

  create_table "prereqs", force: :cascade do |t|
    t.bigint "quest_id"
    t.integer "required_quest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id", "required_quest_id"], name: "index_prereqs_on_quest_id_and_required_quest_id", unique: true
    t.index ["quest_id"], name: "index_prereqs_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.string "name", limit: 25, null: false
    t.boolean "is_published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_quests_on_name", unique: true
  end

  create_table "steps", force: :cascade do |t|
    t.integer "step_number", null: false
    t.integer "points", null: false
    t.string "name", limit: 50, null: false
    t.integer "quest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer", limit: 50, default: "empty", null: false
    t.string "body", limit: 300, default: "empty", null: false
    t.index ["quest_id", "step_number"], name: "index_steps_on_quest_id_and_step_number", unique: true
  end

  create_table "teamquests", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "quest_id", null: false
    t.integer "quest_status", null: false
    t.string "answer_seed", limit: 25, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_step_completed"
    t.index ["quest_id", "team_id"], name: "index_teamquests_on_quest_id_and_team_id", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", limit: 25, null: false
    t.integer "team_captain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ignorejoins", default: false
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "handle", limit: 15
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
    t.string "secret"
    t.string "salt"
    t.index ["handle"], name: "index_users_on_handle", unique: true
  end

  add_foreign_key "prereqs", "quests"
end
