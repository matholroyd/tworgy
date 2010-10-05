# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 7) do

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.integer  "duration"
    t.string   "username"
    t.string   "place"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "factual"
    t.text     "fictional"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tworgies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "twitter_list_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "members_count"
    t.integer  "subscribers_count"
    t.string   "uri"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tworgies", ["user_id", "updated_at"], :name => "index_tworgies_on_user_id_and_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_username"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"

end
