class CreateBranchSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :branch_summaries do |t|
      t.references :branch, foreign_key: true, null: false
      t.date :date, null: false
      t.decimal :total_seconds, precision: 20, scale: 6, null: false

      t.timestamps
    end
    add_index :branch_summaries, [:date, :branch_id], unique: true
  end
end
