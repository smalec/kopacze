class Team < ActiveRecord::Base
  after_initialize :init

  belongs_to :league
  belongs_to :town
  belongs_to :captain, class_name: 'User'
  has_many :players, class_name: 'User', foreign_key: 'team_id', dependent: :nullify
  has_many :invitations, dependent: :destroy
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_id', dependent: :destroy
  has_many :visitor_matches, class_name: 'Match', foreign_key: 'visitor_id', dependent: :destroy
  has_many :send_match_invitations, class_name: 'MatchInvitation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_match_invitations, class_name: 'MatchInvitation', foreign_key: 'receiver_id', dependent: :destroy

  validates :name, presence: true

private
  def init
    self.points ||= 0
    self.scored ||= 0
    self.lost ||= 0
  end
end
