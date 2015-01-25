class Match < ActiveRecord::Base
  belongs_to :home, class_name: 'Team'
  belongs_to :visitor, class_name: 'Team'
  belongs_to :league

  validates :home_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :visitor_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :home, presence: true
  validates :visitor, presence: true

  def vs
    "#{home.name} - #{visitor.name}"
  end

  def result
    "#{home_score}:#{visitor_score}"
  end
end
