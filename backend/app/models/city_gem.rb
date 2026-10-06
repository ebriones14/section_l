class CityGem < ApplicationRecord
  belongs_to :property
  has_many :city_gem_neighbourhoods, dependent: :destroy
  has_many :neighbourhoods, through: :city_gem_neighbourhoods

  validates :name, :category, :short, :long, :maps, presence: true
end
