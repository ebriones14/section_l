module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "Resource not found" }, status: :not_found
      end

      private

      def city_gem_json(city_gem)
        payload = city_gem.as_json(only: %i[id name category short long maps image_url])
        payload["neighbourhoods"] = city_gem.neighbourhoods.as_json(only: %i[id name])
        payload
      end

      def property_json(property, include_city_gems: false)
        payload = property.as_json(
          only: %i[id name address city slug description hero_image_url]
        )
        payload["neighbourhoods"] = property.neighbourhoods.as_json(only: %i[id name])
        if include_city_gems
          payload["city_gems"] = property.city_gems.order(:name).map { |gem| city_gem_json(gem) }
        end
        payload
      end
    end
  end
end
