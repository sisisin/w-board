class CreateImportJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :import_jobs do |t|
      t.string :status, null: false
      t.date :target_date, null: false
      t.string :detail

      t.timestamps
    end
  end
end
