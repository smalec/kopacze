class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.boolean :invitation
      t.boolean :read
      t.integer :team_id
      t.integer :user_id

      t.timestamps
    end
  end
end
