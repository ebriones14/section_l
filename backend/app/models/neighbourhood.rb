class Neighbourhood < ApplicationRecord
  has_many :property_neighbourhoods, dependent: :destroy
  has_many :properties, through: :property_neighbourhoods
  has_many :city_gem_neighbourhoods, dependent: :destroy
  has_many :city_gems, through: :city_gem_neighbourhoods

  validates :name, presence: true, uniqueness: true
end
