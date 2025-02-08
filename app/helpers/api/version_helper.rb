# frozen_string_literal: true

module Api
  module VersionHelper
    def version_definition
      controller.version_definition
    end

    def version_fields(field_name)
      return unless version_definition&.dig(field_name)

      version_definition[field_name][:fields]
    end

    def render_versioned_fields(json, object, field_name)
      fields = version_fields(field_name)
      return unless fields

      fields.each do |field|
        json.set! field, object.public_send(field)
      end
    end

    def render_versioned_collection(json, field_name, collection, &block)
      return unless version_fields(field_name)

      json.set! field_name do
        json.array! collection, &block
      end
    end
  end
end
