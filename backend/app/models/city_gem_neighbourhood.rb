class CityGemNeighbourhood < ApplicationRecord
  belongs_to :city_gem
  belongs_to :neighbourhood

  validates :neighbourhood_id, uniqueness: { scope: :city_gem_id }
end
