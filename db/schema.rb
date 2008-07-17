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

ActiveRecord::Schema.define(:version => 20080717011848) do

  create_table "accounts", :force => true do |t|
    t.string   "email_address"
    t.string   "salt"
    t.string   "encrypted_password"
    t.string   "verification_key"
    t.boolean  "activated",                        :default => false
    t.boolean  "banned",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id",            :limit => 11
  end

  create_table "logins", :force => true do |t|
    t.integer  "account_id", :limit => 11
    t.datetime "created_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "domain"
    t.string   "api_key"
    t.string   "email_address"
    t.string   "support_title"
    t.string   "activation_subject"
    t.string   "recovery_subject"
    t.text     "activation_letter"
    t.text     "recovery_letter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
