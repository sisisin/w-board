# frozen_string_literal: true

class CreateOperatingSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :operating_systems do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :operating_systems, :name, unique: true
  end
end
