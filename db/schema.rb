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

ActiveRecord::Schema[8.0].define(version: 2025_05_28_125054) do
  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["ticket_id"], name: "index_comments_on_ticket_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "status_id"
    t.integer "requester_id"
    t.integer "assigned_agent_id"
    t.index ["assigned_agent_id"], name: "index_tickets_on_assigned_agent_id"
    t.index ["requester_id"], name: "index_tickets_on_requester_id"
    t.index ["status_id"], name: "index_tickets_on_status_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "comments", "tickets"
  add_foreign_key "comments", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "tickets", "statuses"
  add_foreign_key "tickets", "users", column: "assigned_agent_id"
  add_foreign_key "tickets", "users", column: "requester_id"
  add_foreign_key "users", "roles"
end
