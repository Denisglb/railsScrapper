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

ActiveRecord::Schema.define(version: 20190724220838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "influencers", force: :cascade do |t|
    t.string "user"
    t.string "biography"
    t.string "followers"
    t.string "following"
    t.string "businessAcounnt"
    t.string "businessCategory"
    t.string "numberOfPosts"
    t.string "page_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "user"
    t.string "caption"
    t.integer "noOfComments"
    t.string "postedTime"
    t.integer "likes"
    t.string "location"
    t.string "ownerOfPost"
    t.string "isVideo"
    t.string "videoViews"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "influencer_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name"
    t.integer "popularity_of_tag"
    t.string "page_info"
    t.string "user"
    t.string "comment"
    t.integer "comment_count"
    t.integer "like_count"
    t.string "owner_id"
    t.string "date_added"
    t.string "accessibility_caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
