module Api
  module V1
    class NeighbourhoodSerializer < BaseSerializer
      def as_json
        {
          id: record.id,
          name: record.name
        }
      end
    end
  end
end
