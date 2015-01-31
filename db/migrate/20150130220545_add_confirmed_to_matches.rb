class AddConfirmedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :confirmed, :boolean
  end
end
