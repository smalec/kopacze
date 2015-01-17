class League < ActiveRecord::Base
  belongs_to  :town

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
