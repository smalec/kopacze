class Town < ActiveRecord::Base
  has_many :users
  has_many :leagues
  has_many :teams

  validates :name, presence: true
end
