class AddTownIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :town_id, :integer
  end
end
