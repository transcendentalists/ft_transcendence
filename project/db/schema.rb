# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_28_124332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "room_type", null: false
    t.bigint "room_id", null: false
    t.string "message", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_type", "room_id"], name: "index_chat_messages_on_room"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "direct_chat_bans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "banned_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["banned_user_id"], name: "index_direct_chat_bans_on_banned_user_id"
    t.index ["user_id"], name: "index_direct_chat_bans_on_user_id"
  end

  create_table "direct_chat_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "direct_chat_room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["direct_chat_room_id"], name: "index_direct_chat_memberships_on_direct_chat_room_id"
    t.index ["user_id"], name: "index_direct_chat_memberships_on_user_id"
  end

  create_table "direct_chat_rooms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "group_chat_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_chat_room_id", null: false
    t.string "position", default: "member", null: false
    t.boolean "mute", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_chat_room_id"], name: "index_group_chat_memberships_on_group_chat_room_id"
    t.index ["user_id"], name: "index_group_chat_memberships_on_user_id"
  end

  create_table "group_chat_rooms", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "room_type", null: false
    t.string "title", null: false
    t.integer "max_member_count", default: 10, null: false
    t.integer "current_member_count", default: 0, null: false
    t.string "channel_code", null: false
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_group_chat_rooms_on_owner_id"
  end

  create_table "guild_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "guild_id", null: false
    t.string "position", default: "member", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guild_id"], name: "index_guild_memberships_on_guild_id"
    t.index ["user_id"], name: "index_guild_memberships_on_user_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.string "anagram", null: false
    t.string "image_url", default: "default_image_url"
    t.integer "point", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_guilds_on_owner_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "rule_id", null: false
    t.string "eventable_type", null: false
    t.bigint "eventable_id", null: false
    t.string "match_type", null: false
    t.string "status", default: "pending"
    t.datetime "start_time"
    t.integer "target_score", default: 3
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["eventable_type", "eventable_id"], name: "index_matches_on_eventable"
    t.index ["rule_id"], name: "index_matches_on_rule_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "name", default: "basic", null: false
    t.boolean "invisible", default: false, null: false
    t.boolean "dwindle", default: false, null: false
    t.boolean "accel_wall", default: false, null: false
    t.boolean "accel_paddle", default: false, null: false
    t.boolean "bound_wall", default: false, null: false
    t.boolean "bound_paddle", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scorecards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "match_id", null: false
    t.string "side", null: false
    t.integer "score", default: 0, null: false
    t.string "result", default: "wait", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_scorecards_on_match_id"
    t.index ["user_id"], name: "index_scorecards_on_user_id"
  end

  create_table "tournament_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tournament_id", null: false
    t.string "status", default: "pending", null: false
    t.string "result", default: "cooper", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_id"], name: "index_tournament_memberships_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_memberships_on_user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.bigint "rule_id", null: false
    t.string "title", null: false
    t.integer "max_user_count", default: 16, null: false
    t.integer "registered_user_count", default: 0, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.time "tournament_time", null: false
    t.string "incentive_title", default: "super rookie", null: false
    t.string "incentive_gift"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rule_id"], name: "index_tournaments_on_rule_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password", null: false
    t.string "intra_id", null: false
    t.string "image_url", default: "default_image_url", null: false
    t.string "title", default: "beginner", null: false
    t.string "status", default: "offline", null: false
    t.boolean "two_factor_auth", default: false, null: false
    t.boolean "banned", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "war_requests", force: :cascade do |t|
    t.bigint "rule_id", null: false
    t.integer "bet_point", default: 200
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.time "war_time", null: false
    t.integer "max_no_reply_count", default: 5
    t.boolean "include_ladder", default: false
    t.boolean "include_tournament", default: false
    t.integer "target_match_score", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rule_id"], name: "index_war_requests_on_rule_id"
  end

  create_table "war_statuses", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.bigint "war_request_id", null: false
    t.string "position", null: false
    t.integer "no_reply_count", default: 0, null: false
    t.integer "point", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guild_id"], name: "index_war_statuses_on_guild_id"
    t.index ["war_request_id"], name: "index_war_statuses_on_war_request_id"
  end

  create_table "wars", force: :cascade do |t|
    t.bigint "war_request_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["war_request_id"], name: "index_wars_on_war_request_id"
  end

  add_foreign_key "chat_messages", "users"
  add_foreign_key "direct_chat_bans", "users"
  add_foreign_key "direct_chat_bans", "users", column: "banned_user_id"
  add_foreign_key "direct_chat_memberships", "direct_chat_rooms"
  add_foreign_key "direct_chat_memberships", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "group_chat_memberships", "group_chat_rooms"
  add_foreign_key "group_chat_memberships", "users"
  add_foreign_key "group_chat_rooms", "users", column: "owner_id"
  add_foreign_key "guild_memberships", "guilds"
  add_foreign_key "guild_memberships", "users"
  add_foreign_key "guilds", "users", column: "owner_id"
  add_foreign_key "matches", "rules"
  add_foreign_key "scorecards", "matches"
  add_foreign_key "scorecards", "users"
  add_foreign_key "tournament_memberships", "tournaments"
  add_foreign_key "tournament_memberships", "users"
  add_foreign_key "tournaments", "rules"
  add_foreign_key "war_requests", "rules"
  add_foreign_key "war_statuses", "guilds"
  add_foreign_key "war_statuses", "war_requests"
  add_foreign_key "wars", "war_requests"
end
