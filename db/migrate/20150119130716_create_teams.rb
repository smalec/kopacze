class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :league_id
      t.integer :captain_id

      t.timestamps
    end
  end
end
