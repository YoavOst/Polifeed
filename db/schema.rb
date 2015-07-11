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

ActiveRecord::Schema.define(version: 20150411144242) do

  create_table "cliques", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cliques_words", id: false, force: :cascade do |t|
    t.integer "word_id",   limit: 4, null: false
    t.integer "clique_id", limit: 4, null: false
  end

  create_table "parties", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "knesset_seats_20", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "phrase_indices", force: :cascade do |t|
    t.integer "phrase_id",    limit: 4
    t.integer "abs_position", limit: 4
    t.integer "word_id",      limit: 4
  end

  add_index "phrase_indices", ["phrase_id"], name: "fk_rails_ec9d3d1f15", using: :btree
  add_index "phrase_indices", ["word_id"], name: "fk_rails_6731030c3e", using: :btree

  create_table "phrases", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "politicians", force: :cascade do |t|
    t.string   "full_name",           limit: 255
    t.string   "fb_page",             limit: 255
    t.datetime "last_refresh_time"
    t.integer  "party_id",            limit: 4
    t.integer  "location_20",         limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "politicians", ["party_id"], name: "index_politicians_on_party_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.string  "name",          limit: 255
    t.integer "party_id",      limit: 4
    t.integer "politician_id", limit: 4
    t.date    "start_date"
    t.date    "end_date"
    t.integer "phrase_id",     limit: 4
    t.integer "clique_id",     limit: 4
    t.integer "word_id",       limit: 4
    t.boolean "is_exact",      limit: 1
  end

  add_index "searches", ["clique_id"], name: "index_searches_on_clique_id", using: :btree
  add_index "searches", ["party_id"], name: "index_searches_on_party_id", using: :btree
  add_index "searches", ["phrase_id"], name: "index_searches_on_phrase_id", using: :btree
  add_index "searches", ["politician_id"], name: "index_searches_on_politician_id", using: :btree
  add_index "searches", ["word_id"], name: "index_searches_on_word_id", using: :btree

  create_table "status_descs", force: :cascade do |t|
    t.integer  "status_id",  limit: 4
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "status_descs", ["status_id"], name: "index_status_descs_on_status_id", using: :btree

  create_table "status_indices", force: :cascade do |t|
    t.integer "status_id",    limit: 4
    t.integer "abs_position", limit: 4
    t.integer "word_id",      limit: 4
    t.integer "sen_num",      limit: 4
    t.integer "sen_position", limit: 4
  end

  add_index "status_indices", ["status_id"], name: "fk_rails_6b3ac368a4", using: :btree
  add_index "status_indices", ["word_id"], name: "fk_rails_21b696526a", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "fb_status_id",    limit: 255
    t.integer  "politician_id",   limit: 4
    t.datetime "publish_time"
    t.datetime "fb_get_time"
    t.boolean  "is_processed",    limit: 1
    t.integer  "tokens_count",    limit: 4
    t.integer  "words_count",     limit: 4
    t.integer  "sentences_count", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "statuses", ["politician_id"], name: "index_statuses_on_politician_id", using: :btree

  create_table "statuses_tags", id: false, force: :cascade do |t|
    t.integer "status_id", limit: 4, null: false
    t.integer "tag_id",    limit: 4, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["text"], name: "index_tags_on_text", unique: true, using: :btree

  create_table "words", force: :cascade do |t|
    t.string  "text",        limit: 255
    t.integer "chars_count", limit: 4
  end

  add_index "words", ["text"], name: "index_words_on_text", unique: true, using: :btree

  add_foreign_key "phrase_indices", "phrases"
  add_foreign_key "phrase_indices", "words"
  add_foreign_key "politicians", "parties"
  add_foreign_key "searches", "cliques"
  add_foreign_key "searches", "parties"
  add_foreign_key "searches", "phrases"
  add_foreign_key "searches", "politicians"
  add_foreign_key "searches", "words"
  add_foreign_key "status_descs", "statuses"
  add_foreign_key "status_indices", "statuses"
  add_foreign_key "status_indices", "words"
  add_foreign_key "statuses", "politicians"
end
