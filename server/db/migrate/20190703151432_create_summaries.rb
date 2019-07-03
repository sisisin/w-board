class CreateSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :category_summaries do |t|
      t.references :category, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    create_table :dependency_summaries do |t|
      t.references :dependency, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    create_table :editor_summaries do |t|
      t.references :editor, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    create_table :entity_summaries do |t|
      t.references :entity, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    create_table :language_summaries do |t|
      t.references :language, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    create_table :machine_summaries do |t|
      t.references :machine, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    create_table :operating_system_summaries do |t|
      t.references :operating_system, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end

    add_index :category_summaries, [:date, :category_id], unique: true
    add_index :dependency_summaries, [:date, :dependency_id], unique: true
    add_index :editor_summaries, [:date, :editor_id], unique: true
    add_index :entity_summaries, [:date, :entity_id], unique: true
    add_index :language_summaries, [:date, :language_id], unique: true
    add_index :machine_summaries, [:date, :machine_id], unique: true
    add_index :operating_system_summaries, [:date, :operating_system_id], unique: true
  end
end
