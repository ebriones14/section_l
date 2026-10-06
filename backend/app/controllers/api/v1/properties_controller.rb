module Api
  module V1
    class PropertiesController < BaseController
      def index
        properties = Property.includes(:neighbourhoods).order(:name)
        render json: { properties: properties.map { |property| property_json(property) } }
      end

      def show
        property = Property.includes(:neighbourhoods, city_gems: :neighbourhoods).find_by!(slug: params[:slug])
        render json: { property: property_json(property, include_city_gems: true) }
      end
    end
  end
end
