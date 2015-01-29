class MatchInvitation < ActiveRecord::Base
  after_initialize :init

  belongs_to :sender, class_name: 'Team'
  belongs_to :receiver, class_name: 'Team'

  def vs
    "#{sender.name} - #{receiver.name}"
  end

  def self.delete_old_invitations
    invs = MatchInvitation.where(:date => Date.today.to_s)
    for inv in invs
      inv.destroy
    end
  end

private
  def init
    self.read ||= false
    self.accepted ||= false
  end
end
