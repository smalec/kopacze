class League < ActiveRecord::Base
  belongs_to  :town
  has_many :teams, dependent: :destroy
  has_many :matches, dependent: :destroy

  def description
    if division == 0
      return "Ekstraklasa"
    elsif division == 1
      return "1. Liga"
    else
      "Liga #{division}.#{group}"
    end
  end

  def description_with_town
    if division == 0
      return "#{town.name}: Ekstraklasa"
    elsif division == 1
      return "#{town.name}: 1. Liga"
    else
      "#{town.name}: Liga #{division}.#{group}"
    end
  end
end
