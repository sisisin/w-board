# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :languages do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :languages, :name, unique: true
  end
end
