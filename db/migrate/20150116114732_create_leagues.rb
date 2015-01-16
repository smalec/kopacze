class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :division
      t.integer :group
      t.integer :town_id

      t.timestamps
    end
  end
end
