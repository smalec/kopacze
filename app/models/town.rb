class Town < ActiveRecord::Base
  has_many :users
  has_many :leagues
  has_many :teams, through: :leagues

  validates :name, presence: true
end
