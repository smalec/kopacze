class AddHomeIdAndVisitorIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :home_id, :integer
    add_column :matches, :visitor_id, :integer
  end
end
