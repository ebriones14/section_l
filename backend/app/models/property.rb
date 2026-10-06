class Property < ApplicationRecord
  has_many :property_neighbourhoods, dependent: :destroy
  has_many :neighbourhoods, through: :property_neighbourhoods
  has_many :city_gems, -> { distinct }, through: :neighbourhoods

  validates :name, :address, :description, :city, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
end
