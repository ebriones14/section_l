module Api
  module V1
    class CityGemSerializer < BaseSerializer
      def as_json
        {
          id: record.id,
          name: record.name,
          category: record.category,
          short: record.short,
          long: record.long,
          maps: record.maps,
          image_url: record.image_url,
          neighbourhoods: NeighbourhoodSerializer.many(record.neighbourhoods)
        }
      end
    end
  end
end
