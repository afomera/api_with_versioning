# frozen_string_literal: true

module Api
  module Resources
    class Base
      class << self
        def required(field, type)
          field_definitions[field] = { type: type, required: true }
        end

        def optional(field, type)
          field_definitions[field] = { type: type, required: false }
        end

        def field_definitions
          @field_definitions ||= {}
        end

        def validate!(data)
          field_definitions.each do |field, definition|
            if definition[:required] && !data.key?(field)
              raise ValidationError, "Missing required field: #{field}"
            end

            if data.key?(field) && !data[field].is_a?(definition[:type])
              raise ValidationError, "Invalid type for #{field}: expected #{definition[:type]}, got #{data[field].class}"
            end
          end
        end
      end

      class ValidationError < StandardError; end
    end
  end
end
