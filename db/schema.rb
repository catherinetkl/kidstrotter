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

ActiveRecord::Schema[7.0].define(version: 2022_11_23_040328) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "location", null: false
    t.float "price", null: false
    t.string "age_group", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "require_booking", default: false
    t.boolean "require_payment", default: false
    t.bigint "category_id"
    t.bigint "organizer_id"
    t.index ["category_id"], name: "index_activities_on_category_id"
    t.index ["organizer_id"], name: "index_activities_on_organizer_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.string "status", default: "pending"
    t.bigint "activities_id"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "adult_qty", default: 0, null: false
    t.integer "child_qty", default: 0, null: false
    t.float "adult_price", default: 0.0, null: false
    t.float "child_price", default: 0.0, null: false
    t.index ["activities_id"], name: "index_bookings_on_activities_id"
    t.index ["users_id"], name: "index_bookings_on_users_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_bookmarks_on_activity_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizers", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_organizers_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "booking_id"
    t.bigint "user_id"
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "categories"
  add_foreign_key "activities", "organizers"
  add_foreign_key "bookings", "activities", column: "activities_id"
  add_foreign_key "bookings", "users", column: "users_id"
  add_foreign_key "bookmarks", "activities"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "organizers", "users"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users"
end
