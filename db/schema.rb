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

ActiveRecord::Schema.define(:version => 20110322200323) do

  create_table "addresses", :force => true do |t|
    t.integer "person_id"
    t.string  "address_type"
    t.string  "title"
    t.string  "address1"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "phone"
    t.string  "alternate_phone"
    t.string  "dorm"
    t.string  "room"
    t.string  "email"
    t.date    "start_date"
    t.date    "end_date"
    t.date    "created_at"
    t.date    "updated_at"
    t.boolean "email_validated"
  end

  add_index "addresses", ["email"], :name => "index_addresses_on_email"
  add_index "addresses", ["person_id"], :name => "index_addresses_on_person_id"

  create_table "campus_involvements", :force => true do |t|
    t.integer "person_id"
    t.integer "campus_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "ministry_id"
    t.integer "added_by_id"
    t.date    "graduation_date"
    t.integer "school_year_id"
    t.string  "major"
    t.string  "minor"
    t.date    "last_history_update_date"
  end

  add_index "campus_involvements", ["campus_id"], :name => "index_campus_involvements_on_campus_id"
  add_index "campus_involvements", ["ministry_id"], :name => "index_campus_involvements_on_ministry_id"
  add_index "campus_involvements", ["person_id", "campus_id", "end_date"], :name => "index_campus_involvements_on_p_id_and_c_id_and_end_date", :unique => true
  add_index "campus_involvements", ["person_id"], :name => "index_campus_involvements_on_person_id"

  create_table "campus_ministry_groups", :force => true do |t|
    t.integer "group_id"
    t.integer "campus_id"
    t.integer "ministry_id"
  end

  create_table "campuses", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "phone"
    t.string  "fax"
    t.string  "url"
    t.string  "abbrv"
    t.boolean "is_secure"
    t.integer "enrollment"
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "type"
    t.string  "address2"
    t.string  "county"
  end

  add_index "campuses", ["county"], :name => "index_campuses_on_county"
  add_index "campuses", ["name"], :name => "index_campuses_on_name"

  create_table "columns", :force => true do |t|
    t.string   "title"
    t.string   "update_clause"
    t.string   "from_clause"
    t.text     "select_clause"
    t.string   "column_type"
    t.string   "writeable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "join_clause"
    t.string   "source_model"
    t.string   "source_column"
    t.string   "foreign_key"
  end

  create_table "conference_registrations", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "correspondence_types", :force => true do |t|
    t.string  "name"
    t.integer "overdue_lifespan"
    t.integer "expiry_lifespan"
    t.string  "actions_now_task"
    t.string  "actions_overdue_task"
    t.string  "actions_followup_task"
    t.text    "redirect_params"
    t.string  "redirect_target_id_type"
  end

  create_table "correspondences", :force => true do |t|
    t.integer  "correspondence_type_id"
    t.integer  "person_id"
    t.string   "receipt"
    t.string   "state"
    t.date     "visited"
    t.date     "completed"
    t.date     "overdue_at"
    t.date     "expire_at"
    t.text     "token_params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "correspondences", ["receipt"], :name => "index_correspondences_on_receipt"

  create_table "counties", :force => true do |t|
    t.string "name"
    t.string "state"
  end

  add_index "counties", ["state"], :name => "index_counties_on_state"

  create_table "countries", :force => true do |t|
    t.string  "country"
    t.string  "code"
    t.boolean "is_closed"
  end

  create_table "custom_attributes", :force => true do |t|
    t.integer "ministry_id"
    t.string  "name"
    t.string  "value_type"
    t.string  "description"
    t.string  "type"
  end

  add_index "custom_attributes", ["type"], :name => "index_custom_attributes_on_type"

  create_table "custom_values", :force => true do |t|
    t.integer "person_id"
    t.integer "custom_attribute_id"
    t.string  "value"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dismissed_notices", :force => true do |t|
    t.integer  "person_id"
    t.integer  "notice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dorms", :force => true do |t|
    t.integer "campus_id"
    t.string  "name"
    t.date    "created_at"
  end

  add_index "dorms", ["campus_id"], :name => "index_dorms_on_campus_id"

  create_table "email_templates", :force => true do |t|
    t.integer  "correspondence_type_id"
    t.string   "outcome_type"
    t.string   "subject",                :null => false
    t.string   "from",                   :null => false
    t.string   "bcc"
    t.string   "cc"
    t.text     "body",                   :null => false
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.text     "people_ids"
    t.text     "missing_address_ids"
    t.integer  "search_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_campuses", :force => true do |t|
    t.integer  "event_id"
    t.integer  "campus_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_groups", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "registrar_event_id"
    t.integer  "event_group_id"
    t.string   "register_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_times", :force => true do |t|
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "day_of_week"
    t.integer  "timetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css_class"
    t.decimal  "weight",       :precision => 4, :scale => 2
  end

  add_index "free_times", ["timetable_id"], :name => "free_times_timetable_id"

  create_table "global_areas", :force => true do |t|
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "global_countries", :force => true do |t|
    t.string   "name"
    t.integer  "global_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iso3"
    t.integer  "stage"
    t.integer  "live_exp"
    t.integer  "live_dec"
    t.integer  "new_grth_mbr"
    t.integer  "mvmt_mbr"
    t.integer  "mvmt_ldr"
    t.integer  "new_staff"
    t.integer  "lifetime_lab"
  end

  create_table "global_profiles", :force => true do |t|
    t.string   "gender"
    t.string   "marital_status"
    t.string   "language"
    t.string   "mission_critical_components"
    t.string   "funding_source"
    t.string   "staff_status"
    t.string   "employment_country"
    t.string   "ministry_location_country"
    t.string   "position"
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_involvements", :force => true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.string   "level"
    t.boolean  "requested"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_involvements", ["person_id", "group_id"], :name => "person_id_group_id", :unique => true

  create_table "group_types", :force => true do |t|
    t.integer  "ministry_id"
    t.string   "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mentor_priority"
    t.boolean  "public"
    t.integer  "unsuitability_leader"
    t.integer  "unsuitability_coleader"
    t.integer  "unsuitability_participant"
    t.string   "collection_group_name",      :default => "{{campus}} interested in a {{group_type}}"
    t.boolean  "has_collection_groups",      :default => false
    t.boolean  "in_directory_search_not_in", :default => false
    t.string   "short_name"
    t.boolean  "in_directory_search_in",     :default => false
  end

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "email"
    t.string  "url"
    t.integer "dorm_id"
    t.integer "ministry_id"
    t.integer "campus_id"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "day"
    t.integer "group_type_id"
    t.boolean "needs_approval"
    t.integer "semester_id"
  end

  add_index "groups", ["campus_id"], :name => "index_groups_on_campus_id"
  add_index "groups", ["dorm_id"], :name => "index_groups_on_dorm_id"
  add_index "groups", ["ministry_id"], :name => "index_groups_on_ministry_id"
  add_index "groups", ["semester_id"], :name => "index_emu.groups_on_semester_id"

  create_table "imports", :force => true do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "involvement_histories", :force => true do |t|
    t.string   "type"
    t.integer  "person_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "campus_id"
    t.integer  "school_year_id"
    t.integer  "ministry_id"
    t.integer  "ministry_role_id"
    t.integer  "campus_involvement_id"
    t.integer  "ministry_involvement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locks", :force => true do |t|
    t.string   "name"
    t.boolean  "locked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ministries", :force => true do |t|
    t.integer "parent_id"
    t.string  "name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "phone"
    t.string  "fax"
    t.string  "email"
    t.string  "url"
    t.date    "created_at"
    t.date    "updated_at"
    t.integer "ministries_count"
    t.string  "type"
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "ministries", ["lft"], :name => "index_emu.ministries_on_lft"
  add_index "ministries", ["parent_id"], :name => "index_emu.ministries_on_parent_id"
  add_index "ministries", ["parent_id"], :name => "index_ministries_on_parent_id"
  add_index "ministries", ["rgt"], :name => "index_emu.ministries_on_rgt"

  create_table "ministry_campuses", :force => true do |t|
    t.integer "ministry_id"
    t.integer "campus_id"
  end

  add_index "ministry_campuses", ["ministry_id", "campus_id"], :name => "index_ministry_campuses_on_ministry_id_and_campus_id", :unique => true

  create_table "ministry_involvements", :force => true do |t|
    t.integer "person_id"
    t.integer "ministry_id"
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "admin"
    t.integer "ministry_role_id"
    t.integer "responsible_person_id"
    t.date    "last_history_update_date"
  end

  add_index "ministry_involvements", ["person_id"], :name => "index_ministry_involvements_on_person_id"

  create_table "ministry_role_permissions", :force => true do |t|
    t.integer "permission_id"
    t.integer "ministry_role_id"
    t.string  "created_at"
  end

  create_table "ministry_roles", :force => true do |t|
    t.integer "ministry_id"
    t.string  "name"
    t.date    "created_at"
    t.integer "position"
    t.string  "description"
    t.string  "type"
    t.boolean "involved"
  end

  add_index "ministry_roles", ["ministry_id"], :name => "index_ministry_roles_on_ministry_id"

  create_table "notices", :force => true do |t|
    t.text     "message"
    t.boolean  "live"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.integer "user_id"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "middle_name"
    t.string  "preferred_name"
    t.string  "gender"
    t.string  "year_in_school"
    t.string  "level_of_school"
    t.date    "graduation_date"
    t.string  "major"
    t.string  "minor"
    t.date    "birth_date"
    t.text    "bio"
    t.string  "image"
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "staff_notes"
    t.integer "updated_by"
    t.integer "created_by"
    t.string  "url",                           :limit => 2000
    t.integer "primary_campus_involvement_id"
    t.integer "mentor_id"
  end

  add_index "people", ["first_name"], :name => "index_people_on_first_name"
  add_index "people", ["last_name", "first_name"], :name => "index_people_on_last_name_and_first_name"
  add_index "people", ["major", "minor"], :name => "index_people_on_major_and_minor"
  add_index "people", ["user_id"], :name => "index_people_on_user_id", :unique => true

  create_table "permissions", :force => true do |t|
    t.string "description", :limit => 1000
    t.string "controller"
    t.string "action"
  end

  create_table "person_extras", :force => true do |t|
    t.integer "person_id"
    t.string  "major"
    t.string  "minor"
    t.string  "url"
    t.string  "staff_notes"
    t.string  "updated_at"
    t.string  "updated_by"
    t.date    "perm_start_date"
    t.date    "perm_end_date"
    t.string  "perm_dorm"
    t.string  "perm_room"
    t.string  "perm_alternate_phone"
    t.date    "curr_start_date"
    t.date    "curr_end_date"
    t.string  "curr_dorm"
    t.string  "curr_room"
  end

  add_index "person_extras", ["person_id"], :name => "index_person_extras_on_person_id"

  create_table "profile_pictures", :force => true do |t|
    t.integer "person_id"
    t.integer "parent_id"
    t.integer "size"
    t.integer "height"
    t.integer "width"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.date    "uploaded_date"
  end

  create_table "school_years", :force => true do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "person_id"
    t.text     "options"
    t.text     "query"
    t.text     "tables"
    t.boolean  "saved"
    t.string   "name"
    t.string   "order"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "staff", :force => true do |t|
    t.integer "ministry_id"
    t.integer "person_id"
    t.date    "created_at"
  end

  add_index "staff", ["ministry_id"], :name => "index_staff_on_ministry_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stint_applications", :force => true do |t|
    t.integer  "stint_location_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stint_locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strategies", :force => true do |t|
    t.string "name"
    t.string "abbrv"
  end

  create_table "summer_project_applications", :force => true do |t|
    t.integer  "summer_project_id"
    t.integer  "person_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summer_projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_group_involvements", :id => false, :force => true do |t|
    t.integer "person_id"
    t.string  "group_involvements"
  end

  add_index "temp_group_involvements", ["person_id"], :name => "index_temp_group_involvements_on_person_id"

  create_table "timetables", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by_person_id"
  end

  add_index "timetables", ["person_id"], :name => "index_c4c_pulse_dev.timetables_on_person_id"

  create_table "training_answers", :force => true do |t|
    t.integer  "training_question_id"
    t.integer  "person_id"
    t.date     "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "approved_by"
  end

  create_table "training_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ministry_id"
  end

  create_table "training_question_activations", :force => true do |t|
    t.integer  "ministry_id"
    t.integer  "training_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mandate"
  end

  create_table "training_questions", :force => true do |t|
    t.string   "activity"
    t.integer  "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_category_id"
  end

  create_table "user_codes", :force => true do |t|
    t.integer  "user_id"
    t.string   "code"
    t.binary   "pass"
    t.integer  "click_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_codes", ["user_id"], :name => "index_user_codes_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "last_login"
    t.boolean  "system_admin"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.boolean  "email_validated"
    t.boolean  "developer"
    t.string   "facebook_hash"
    t.string   "facebook_username"
  end

  add_index "users", ["guid"], :name => "index_users_on_guid", :unique => true

  create_table "view_columns", :force => true do |t|
    t.string   "view_id"
    t.string   "column_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "view_columns", ["column_id", "view_id"], :name => "view_columns_column_id"
  add_index "view_columns", ["view_id"], :name => "index_view_columns_on_view_id"

  create_table "views", :force => true do |t|
    t.string   "title"
    t.string   "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_view"
    t.string   "select_clause", :limit => 2000
    t.string   "tables_clause", :limit => 2000
  end

end
