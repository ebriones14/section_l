module Api
  module V1
    class BaseSerializer
      def self.one(record, **options)
        new(record, **options).as_json
      end

      def self.many(records, **options)
        records.map { |record| one(record, **options) }
      end

      def initialize(record)
        @record = record
      end

      private

      attr_reader :record
    end
  end
end
