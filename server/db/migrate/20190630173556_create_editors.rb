# frozen_string_literal: true

class CreateEditors < ActiveRecord::Migration[5.2]
  def change
    create_table :editors do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :editors, :name, unique: true
  end
end
