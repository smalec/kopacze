class AddScoredAndLostToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :scored, :integer
    add_column :teams, :lost, :integer
  end
end
