# frozen_string_literal: true

class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :entities, :name, unique: true
  end
end
