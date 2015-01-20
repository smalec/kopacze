class Team < ActiveRecord::Base
  belongs_to :league
  belongs_to :town
  belongs_to :captain, class_name: 'User'
  has_many :players, class_name: 'User', foreign_key: 'team_id', dependent: :nullify

  validates :name, presence: true
end
