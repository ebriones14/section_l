module Api
  module V1
    class CityGemsController < BaseController
      def index
        city_gems = CityGem.includes(:neighbourhoods).order(:category, :name)
        render json: { city_gems: city_gems.map { |gem| city_gem_json(gem) } }
      end
    end
  end
end
