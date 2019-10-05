# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_05_103845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deleted_urls", force: :cascade do |t|
    t.string "prev_url"
    t.string "next_url"
    t.datetime "created_at"
    t.index ["prev_url"], name: "index_deleted_urls_on_prev_url", unique: true
  end

end
