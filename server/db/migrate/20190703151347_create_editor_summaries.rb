class CreateEditorSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :editor_summaries do |t|
      t.references :editor, foreign_key: true
      t.date :date
      t.decimal :total_seconds, precision: 20, scale: 6

      t.timestamps
    end
  end
end
