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

ActiveRecord::Schema.define(version: 2019_07_03_182640) do

  create_table "branch_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_branch_summaries_on_branch_id"
    t.index ["date", "branch_id"], name: "index_branch_summaries_on_date_and_branch_id", unique: true
  end

  create_table "branches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_branches_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_branches_on_project_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_categories_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_categories_on_project_id"
  end

  create_table "category_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_summaries_on_category_id"
    t.index ["date", "category_id"], name: "index_category_summaries_on_date_and_category_id", unique: true
  end

  create_table "dependencies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_dependencies_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_dependencies_on_project_id"
  end

  create_table "dependency_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "dependency_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "dependency_id"], name: "index_dependency_summaries_on_date_and_dependency_id", unique: true
    t.index ["dependency_id"], name: "index_dependency_summaries_on_dependency_id"
  end

  create_table "editor_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "editor_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "editor_id"], name: "index_editor_summaries_on_date_and_editor_id", unique: true
    t.index ["editor_id"], name: "index_editor_summaries_on_editor_id"
  end

  create_table "editors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_editors_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_editors_on_project_id"
  end

  create_table "entities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_entities_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_entities_on_project_id"
  end

  create_table "entity_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "entity_id"], name: "index_entity_summaries_on_date_and_entity_id", unique: true
    t.index ["entity_id"], name: "index_entity_summaries_on_entity_id"
  end

  create_table "import_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "status", null: false
    t.date "target_date", null: false
    t.string "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "language_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "language_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "language_id"], name: "index_language_summaries_on_date_and_language_id", unique: true
    t.index ["language_id"], name: "index_language_summaries_on_language_id"
  end

  create_table "languages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_languages_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_languages_on_project_id"
  end

  create_table "machine_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "machine_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "machine_id"], name: "index_machine_summaries_on_date_and_machine_id", unique: true
    t.index ["machine_id"], name: "index_machine_summaries_on_machine_id"
  end

  create_table "machines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.string "machine_name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_machines_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_machines_on_project_id"
  end

  create_table "operating_system_summaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "operating_system_id", null: false
    t.date "date", null: false
    t.decimal "total_seconds", precision: 20, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "operating_system_id"], name: "index_operating_system_summaries_on_date_and_operating_system_id", unique: true
    t.index ["operating_system_id"], name: "index_operating_system_summaries_on_operating_system_id"
  end

  create_table "operating_systems", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_operating_systems_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_operating_systems_on_project_id"
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  add_foreign_key "branch_summaries", "branches"
  add_foreign_key "branches", "projects"
  add_foreign_key "categories", "projects"
  add_foreign_key "category_summaries", "categories"
  add_foreign_key "dependencies", "projects"
  add_foreign_key "dependency_summaries", "dependencies"
  add_foreign_key "editor_summaries", "editors"
  add_foreign_key "editors", "projects"
  add_foreign_key "entities", "projects"
  add_foreign_key "entity_summaries", "entities"
  add_foreign_key "language_summaries", "languages"
  add_foreign_key "languages", "projects"
  add_foreign_key "machine_summaries", "machines"
  add_foreign_key "machines", "projects"
  add_foreign_key "operating_system_summaries", "operating_systems"
  add_foreign_key "operating_systems", "projects"
end
