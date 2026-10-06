module Api
  module V1
    class PropertiesController < BaseController
      def index
        properties = Property.strict_loading.includes(:neighbourhoods).order(:name)
        render json: { properties: PropertySerializer.many(properties) }
      end

      def show
        property = Property.strict_loading
          .includes(:neighbourhoods, city_gems: :neighbourhoods)
          .find_by!(slug: params[:slug])

        render json: { property: PropertySerializer.one(property, include_city_gems: true) }
      end
    end
  end
end
