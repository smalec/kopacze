class Town < ActiveRecord::Base
  validates :name, presence: true
end
