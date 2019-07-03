class CreateMachineSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :machine_summaries do |t|
      t.references :machine, foreign_key: true
      t.date :date
      t.decimal :total_seconds, precision: 20, scale: 6

      t.timestamps
    end
  end
end
