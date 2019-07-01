class CreateDependencies < ActiveRecord::Migration[5.2]
  def change
    create_table :dependencies do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :dependencies, :name, unique: true
  end
end
