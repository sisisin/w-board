# frozen_string_literal: true

class CreateBranches < ActiveRecord::Migration[5.2]
  def change
    create_table :branches do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :branches, :name, unique: true
  end
end
