module Api
  module V1
    class PropertySerializer < BaseSerializer
      def initialize(property, include_city_gems: false)
        super(property)
        @include_city_gems = include_city_gems
      end

      def as_json
        payload = {
          id: record.id,
          name: record.name,
          address: record.address,
          city: record.city,
          slug: record.slug,
          description: record.description,
          hero_image_url: record.hero_image_url,
          neighbourhoods: NeighbourhoodSerializer.many(record.neighbourhoods)
        }

        if include_city_gems?
          payload[:city_gems] = CityGemSerializer.many(record.city_gems.sort_by(&:name))
        end

        payload
      end

      private

      def include_city_gems?
        @include_city_gems
      end
    end
  end
end
