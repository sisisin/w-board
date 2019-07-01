class CreateMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :name, null: false
      t.string :machine_name_id, null: false

      t.timestamps
    end
    add_index :machines, :name, unique: true
  end
end
