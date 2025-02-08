# frozen_string_literal: true

module Api
  class AbstractVersionChange
    class << self
      def description(text)
        @description = text
      end

      def response(resource_class, &block)
        @resource_class = resource_class
        instance_eval(&block)
      end

      def change(field, type_old:, type_new:)
        @changes ||= []
        @changes << {
          field: field,
          from: type_old,
          to: type_new
        }
      end

      def run(&block)
        @transformer = block
      end

      def transform(data)
        return data unless applies_to?(data)
        @transformer.call(data)
      end

      def applies_to?(data)
        return false unless @resource_class
        
        begin
          @resource_class.validate!(data)
          true
        rescue Resources::Base::ValidationError
          false
        end
      end

      def changes
        @changes || []
      end

      def description_text
        @description
      end

      def resource_class
        @resource_class
      end
    end
  end
end
