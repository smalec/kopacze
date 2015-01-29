class CreateMatchInvitations < ActiveRecord::Migration
  def change
    create_table :match_invitations do |t|
      t.date :date
      t.string :place
      t.boolean :read
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
