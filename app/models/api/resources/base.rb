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

            if data.key?(field)
              types = Array(definition[:type])
              valid = types.any? { |type| data[field].is_a?(type) }

              unless valid
                Rails.logger.error("Invalid type for #{field}: expected one of #{types.join(', ')}, got #{data[field].class}")
                raise ValidationError, "Invalid type for #{field}: expected one of #{types.join(', ')}, got #{data[field].class}"
              end
            end
          end
        end
      end

      class ValidationError < StandardError; end
    end
  end
end
