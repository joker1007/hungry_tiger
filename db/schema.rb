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

ActiveRecord::Schema.define(:version => 20100325142716) do

  create_table "admins", :force => true do |t|
    t.string   "account",    :null => false
    t.string   "password",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meal_statuses", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.integer  "meal_id",         :null => false
    t.date     "date",            :null => false
    t.string   "type",            :null => false
    t.integer  "matched_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meal_statuses", ["date"], :name => "index_meal_statuses_on_date"
  add_index "meal_statuses", ["user_id", "meal_id"], :name => "index_meal_statuses_on_user_id_and_meal_id", :unique => true
  add_index "meal_statuses", ["user_id"], :name => "index_meal_statuses_on_user_id"

  create_table "meals", :force => true do |t|
    t.date     "date",       :null => false
    t.string   "type",       :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meals", ["date", "type"], :name => "index_meals_on_date_and_type", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                            :null => false
    t.string   "room",                            :null => false
    t.boolean  "no_meal_flag", :default => false
    t.string   "keyword",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
