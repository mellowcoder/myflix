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

ActiveRecord::Schema.define(version: 20140616200046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["user_id"], name: "index_invites_on_user_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "stripe_reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "queue_items", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "queue_items", ["user_id"], name: "index_queue_items_on_user_id", using: :btree
  add_index "queue_items", ["video_id"], name: "index_queue_items_on_video_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: true do |t|
    t.text     "content"
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree
  add_index "reviews", ["video_id"], name: "index_reviews_on_video_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.integer  "invite_id"
    t.boolean  "admin"
    t.string   "stripe_customer_id"
    t.boolean  "active",               default: true
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "large_cover"
    t.string   "small_cover"
    t.string   "video_url"
  end

  add_index "videos", ["category_id"], name: "index_videos_on_category_id", using: :btree

end
