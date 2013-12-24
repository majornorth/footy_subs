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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131224174516) do

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "events", :force => true do |t|
    t.datetime "start"
    t.text     "location"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "organizer_id"
    t.integer  "needed",       :default => 1
    t.string   "league"
    t.string   "field_type"
    t.string   "skill_level"
    t.text     "note"
    t.string   "status"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "email"
    t.string   "password_digest"
    t.string   "mobile"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
    t.boolean  "opt_out",         :default => false
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
