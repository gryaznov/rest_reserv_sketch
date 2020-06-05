# frozen_string_literal: true

class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :tables do |t|
      t.integer :number, null: false
      t.integer :restaurant_id
    end

    add_index :tables, %i[number restaurant_id], unique: true
  end
end
