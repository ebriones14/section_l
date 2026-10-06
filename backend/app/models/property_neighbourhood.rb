class PropertyNeighbourhood < ApplicationRecord
  belongs_to :property
  belongs_to :neighbourhood

  validates :neighbourhood_id, uniqueness: { scope: :property_id }
end
