class AddTownIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :town_id, :integer
  end
end
