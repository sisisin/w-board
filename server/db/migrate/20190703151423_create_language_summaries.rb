class CreateLanguageSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :language_summaries do |t|
      t.references :language, foreign_key: true
      t.date :date
      t.decimal :total_seconds, precision: 20, scale: 6

      t.timestamps
    end
  end
end
