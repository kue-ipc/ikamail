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

ActiveRecord::Schema.define(version: 2019_10_03_023137) do

  create_table "bulk_mails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_template_id", null: false
    t.string "subject"
    t.text "body"
    t.bigint "user_id", null: false
    t.datetime "delivery_datetime"
    t.integer "number"
    t.bigint "mail_status_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "immediate_delivery", null: false
    t.index ["mail_status_id"], name: "index_bulk_mails_on_mail_status_id"
    t.index ["mail_template_id"], name: "index_bulk_mails_on_mail_template_id"
    t.index ["user_id"], name: "index_bulk_mails_on_user_id"
  end

  create_table "excluded_mail_users_recipient_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_user_id"
    t.bigint "recipient_list_id"
    t.index ["mail_user_id"], name: "index_excluded_mail_users_recipient_lists_on_mail_user_id"
    t.index ["recipient_list_id"], name: "index_excluded_mail_users_recipient_lists_on_recipient_list_id"
  end

  create_table "included_mail_users_recipient_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_user_id"
    t.bigint "recipient_list_id"
    t.index ["mail_user_id"], name: "index_included_mail_users_recipient_lists_on_mail_user_id"
    t.index ["recipient_list_id"], name: "index_included_mail_users_recipient_lists_on_recipient_list_id"
  end

  create_table "mail_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_mail_groups_on_name", unique: true
  end

  create_table "mail_groups_recipient_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_group_id"
    t.bigint "recipient_list_id"
    t.index ["mail_group_id"], name: "index_mail_groups_recipient_lists_on_mail_group_id"
    t.index ["recipient_list_id"], name: "index_mail_groups_recipient_lists_on_recipient_list_id"
  end

  create_table "mail_groups_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_group_id"
    t.bigint "mail_user_id"
    t.index ["mail_group_id"], name: "index_mail_groups_users_on_mail_group_id"
    t.index ["mail_user_id"], name: "index_mail_groups_users_on_mail_user_id"
  end

  create_table "mail_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mail_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.bigint "recipient_list_id"
    t.string "from_name"
    t.string "from_mail_address"
    t.string "subject_prefix"
    t.string "subject_postfix"
    t.text "body_header"
    t.text "body_footer"
    t.integer "count"
    t.time "reservation_time"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipient_list_id"], name: "index_mail_templates_on_recipient_list_id"
  end

  create_table "mail_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "mail"
    t.string "name"
    t.string "display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mail"], name: "index_mail_users_on_mail", unique: true
    t.index ["name"], name: "index_mail_users_on_name", unique: true
  end

  create_table "recipient_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bulk_mails", "mail_statuses"
  add_foreign_key "bulk_mails", "mail_templates"
  add_foreign_key "bulk_mails", "users"
end
