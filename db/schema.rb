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

ActiveRecord::Schema.define(version: 2019_11_12_071000) do

  create_table "action_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "bulk_mail_id", null: false
    t.bigint "user_id"
    t.integer "action", null: false
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action"], name: "index_action_logs_on_action"
    t.index ["bulk_mail_id"], name: "index_action_logs_on_bulk_mail_id"
    t.index ["user_id"], name: "index_action_logs_on_user_id"
  end

  create_table "bulk_mails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "template_id", null: false
    t.integer "delivery_timing", null: false
    t.string "subject", null: false
    t.text "body", null: false
    t.datetime "delivered_at"
    t.integer "number"
    t.integer "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["delivery_timing"], name: "index_bulk_mails_on_delivery_timing"
    t.index ["status"], name: "index_bulk_mails_on_status"
    t.index ["template_id"], name: "index_bulk_mails_on_template_id"
    t.index ["user_id"], name: "index_bulk_mails_on_user_id"
  end

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "mail_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", null: false
    t.string "display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_mail_groups_on_name", unique: true
  end

  create_table "mail_groups_recipient_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_group_id", null: false
    t.bigint "recipient_list_id", null: false
    t.index ["mail_group_id"], name: "index_mail_groups_recipient_lists_on_mail_group_id"
    t.index ["recipient_list_id"], name: "index_mail_groups_recipient_lists_on_recipient_list_id"
  end

  create_table "mail_groups_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_group_id", null: false
    t.bigint "mail_user_id", null: false
    t.index ["mail_group_id"], name: "index_mail_groups_users_on_mail_group_id"
    t.index ["mail_user_id"], name: "index_mail_groups_users_on_mail_user_id"
  end

  create_table "mail_memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "mail_user_id", null: false
    t.bigint "mail_group_id", null: false
    t.boolean "primary", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mail_group_id"], name: "index_mail_memberships_on_mail_group_id"
    t.index ["mail_user_id"], name: "index_mail_memberships_on_mail_user_id"
  end

  create_table "mail_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "mail", null: false
    t.string "name", null: false
    t.string "display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mail"], name: "index_mail_users_on_mail", unique: true
    t.index ["name"], name: "index_mail_users_on_name", unique: true
  end

  create_table "recipient_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_recipient_lists_on_name", unique: true
  end

  create_table "recipients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "recipient_list_id", null: false
    t.bigint "mail_user_id", null: false
    t.boolean "included", default: false, null: false
    t.boolean "excluded", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mail_user_id"], name: "index_recipients_on_mail_user_id"
    t.index ["recipient_list_id"], name: "index_recipients_on_recipient_list_id"
  end

  create_table "templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "enabled", default: true, null: false
    t.bigint "user_id", null: false
    t.bigint "recipient_list_id", null: false
    t.string "from_name"
    t.string "from_mail_address", null: false
    t.string "subject_prefix"
    t.string "subject_postfix"
    t.text "body_header"
    t.text "body_footer"
    t.integer "count", default: 0, null: false
    t.time "reserved_time", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_templates_on_name", unique: true
    t.index ["recipient_list_id"], name: "index_templates_on_recipient_list_id"
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "fullname"
    t.integer "role", default: 0, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "remember_created_at"
    t.string "remember_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "action_logs", "bulk_mails"
  add_foreign_key "action_logs", "users"
  add_foreign_key "bulk_mails", "templates"
  add_foreign_key "bulk_mails", "users"
  add_foreign_key "mail_groups_recipient_lists", "mail_groups"
  add_foreign_key "mail_groups_recipient_lists", "recipient_lists"
  add_foreign_key "mail_groups_users", "mail_groups"
  add_foreign_key "mail_groups_users", "mail_users"
  add_foreign_key "mail_memberships", "mail_groups"
  add_foreign_key "mail_memberships", "mail_users"
  add_foreign_key "recipients", "mail_users"
  add_foreign_key "recipients", "recipient_lists"
  add_foreign_key "templates", "recipient_lists"
  add_foreign_key "templates", "users"
end
