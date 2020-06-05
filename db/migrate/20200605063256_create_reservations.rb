# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.date    :date
      t.integer :from
      t.integer :till
      t.belongs_to :user
      t.belongs_to :table

      t.timestamps
    end
  end
end
