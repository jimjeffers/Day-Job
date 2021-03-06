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

ActiveRecord::Schema.define(:version => 20100817222207) do

  create_table "features", :force => true do |t|
    t.string   "name"
    t.string   "aasm_state"
    t.text     "description"
    t.integer  "created_by"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "features", ["aasm_state"], :name => "index_features_on_aasm_state"
  add_index "features", ["project_id"], :name => "index_features_on_project_id"

  create_table "invitations", :force => true do |t|
    t.string   "aasm_state"
    t.string   "token"
    t.string   "email"
    t.integer  "admin",      :default => 0
    t.integer  "owner",      :default => 0
    t.integer  "created_by"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["created_by"], :name => "index_invitations_on_created_by"
  add_index "invitations", ["project_id"], :name => "index_invitations_on_project_id"
  add_index "invitations", ["token"], :name => "index_invitations_on_token"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "aasm_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["aasm_state"], :name => "index_projects_on_aasm_state"

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.float    "hours"
    t.string   "aasm_state"
    t.integer  "completed_by"
    t.date     "completed_on"
    t.integer  "created_by"
    t.integer  "assigned_to"
    t.integer  "feature_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_updated_by"
  end

  add_index "tasks", ["aasm_state"], :name => "index_tasks_on_aasm_state"
  add_index "tasks", ["assigned_to"], :name => "index_tasks_on_assigned_to"
  add_index "tasks", ["completed_by"], :name => "index_tasks_on_completed_by"
  add_index "tasks", ["created_by"], :name => "index_tasks_on_created_by"
  add_index "tasks", ["feature_id"], :name => "index_tasks_on_feature_id"
  add_index "tasks", ["last_updated_by"], :name => "index_tasks_on_last_updated_by"

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "real_name"
  end

  add_index "users", ["crypted_password"], :name => "index_users_on_crypted_password"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["password_salt"], :name => "index_users_on_password_salt"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
