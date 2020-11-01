class DropRefToProject < ActiveRecord::Migration[6.0]
  def up
    remove_index :categories, [:name, :project_id]
    remove_index :dependencies, [:name, :project_id]
    remove_index :editors, [:name, :project_id]
    remove_index :languages, [:name, :project_id]
    remove_index :machines, [:name, :project_id]
    remove_index :operating_systems, [:name, :project_id]

    remove_reference :categories, :project, foreign_key: true, null: false, after: :id
    remove_reference :dependencies, :project, foreign_key: true, null: false, after: :id
    remove_reference :editors, :project, foreign_key: true, null: false, after: :id
    remove_reference :languages, :project, foreign_key: true, null: false, after: :id
    remove_reference :machines, :project, foreign_key: true, null: false, after: :id
    remove_reference :operating_systems, :project, foreign_key: true, null: false, after: :id

    add_index :categories, :name, unique: true
    add_index :dependencies, :name, unique: true
    add_index :editors, :name, unique: true
    add_index :languages, :name, unique: true
    add_index :machines, :name, unique: true
    add_index :operating_systems, :name, unique: true
  end

  def down
    add_reference :categories, :project, foreign_key: true, null: false, after: :id
    add_reference :dependencies, :project, foreign_key: true, null: false, after: :id
    add_reference :editors, :project, foreign_key: true, null: false, after: :id
    add_reference :languages, :project, foreign_key: true, null: false, after: :id
    add_reference :machines, :project, foreign_key: true, null: false, after: :id
    add_reference :operating_systems, :project, foreign_key: true, null: false, after: :id

    remove_index :categories, :name
    remove_index :dependencies, :name
    remove_index :editors, :name
    remove_index :languages, :name
    remove_index :machines, :name
    remove_index :operating_systems, :name

    add_index :categories, [:name, :project_id], unique: true
    add_index :dependencies, [:name, :project_id], unique: true
    add_index :editors, [:name, :project_id], unique: true
    add_index :languages, [:name, :project_id], unique: true
    add_index :machines, [:name, :project_id], unique: true
    add_index :operating_systems, [:name, :project_id], unique: true
  end
end
