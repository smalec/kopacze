class AddAcceptedToMatchInvitations < ActiveRecord::Migration
  def change
    add_column :match_invitations, :accepted, :boolean
  end
end
