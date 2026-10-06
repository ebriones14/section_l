class Property < ApplicationRecord
  has_many :city_gems, -> { order(:name) }, dependent: :destroy
  has_many :property_neighbourhoods, dependent: :destroy
  has_many :neighbourhoods, through: :property_neighbourhoods

  validates :name, :address, :description, :city, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
end
