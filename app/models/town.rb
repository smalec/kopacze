class Town < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :leagues, dependent: :destroy
  has_many :teams, dependent: :destroy

  validates :name, presence: true
end
