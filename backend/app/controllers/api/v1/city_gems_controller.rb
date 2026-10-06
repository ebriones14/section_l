module Api
  module V1
    class CityGemsController < BaseController
      def index
        city_gems = CityGem.strict_loading.includes(:neighbourhoods).order(:category, :name)
        render json: { city_gems: CityGemSerializer.many(city_gems) }
      end
    end
  end
end
