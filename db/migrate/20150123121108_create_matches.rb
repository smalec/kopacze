class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_score
      t.integer :visitor_score
      t.integer :home_scorers, array: true, default: []
      t.integer :visitor_scorers, array: true, default: []
      t.date :date

      t.timestamps
    end
  end
end
