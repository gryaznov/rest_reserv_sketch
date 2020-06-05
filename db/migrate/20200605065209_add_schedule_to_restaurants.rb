class AddScheduleToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :opening_time, :string
    add_column :restaurants, :closing_time, :string
  end
end
