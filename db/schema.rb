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

ActiveRecord::Schema.define(version: 20151110222527) do

  create_table "lists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lists", ["user_id"], name: "index_lists_on_user_id"

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todo_tags", force: :cascade do |t|
    t.integer  "todo_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "todo_tags", ["tag_id"], name: "index_todo_tags_on_tag_id"
  add_index "todo_tags", ["todo_id"], name: "index_todo_tags_on_todo_id"

  create_table "todos", force: :cascade do |t|
    t.integer "list_id"
    t.string  "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_hash"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
