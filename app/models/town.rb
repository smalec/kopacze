class Town < ActiveRecord::Base
  has_many :users
  has_many :leagues

  validates :name, presence: true
end
