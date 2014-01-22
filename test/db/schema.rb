
ActiveRecord::Schema.define do

  self.verbose = false

  # Copied over from Beacon...

  create_table "authorizations", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "provider",      null: false
    t.string   "uid",           null: false
    t.string   "link"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "token"
    t.string   "secret"
    t.boolean  "expires"
    t.integer  "expires_at"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "authorizations", ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true, using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree


  create_table "users", force: true do |t|
    t.string   "full_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
