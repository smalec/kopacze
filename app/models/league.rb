class League < ActiveRecord::Base
  belongs_to  :town

  validates :division, :numericality => { :greater_than_or_equal_to => 0 }
  validates :group, :numericality => { :greater_than => 0 }

  def description
    if division == 0
      return "Ekstraklasa"
    elsif division == 1
      return "1. Liga"
    else
      "Liga #{division}.#{group}"
    end
  end
end
