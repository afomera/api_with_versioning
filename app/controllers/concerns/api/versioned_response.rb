# frozen_string_literal: true

module Api
  module VersionedResponse
    extend ActiveSupport::Concern

    included do
      class_attribute :version_definitions, default: {}
      before_action :validate_api_version
    end

    class_methods do
      def versioned_response(&block)
        DSL.new(self).instance_eval(&block)
      end
    end

    def version_definition
      self.class.version_definitions[current_api_version.to_s]
    end

    private

    def current_api_version
      @current_api_version ||= begin
        version_string = request.headers["Accept"]&.match(/version=(\d{4}-\d{2}-\d{2})/)&.[](1)
        Version.new(version_string || latest_version)
      end
    end

    def latest_version
      self.class.version_definitions.keys.max
    end

    def validate_api_version
      unless self.class.version_definitions.key?(current_api_version.to_s)
        raise ActionController::BadRequest, "Unsupported API version: #{current_api_version}"
      end
    end

    class DSL
      def initialize(controller_class)
        @controller_class = controller_class
      end

      def version(version_string, &block)
        definition = VersionDefinition.new
        definition.instance_eval(&block)
        @controller_class.version_definitions[version_string] = definition.to_h
      end
    end

    class VersionDefinition
      def initialize
        @fields = {}
      end

      def field(name, &block)
        field_def = FieldDefinition.new
        field_def.instance_eval(&block) if block_given?
        @fields[name] = field_def.to_h
      end

      def to_h
        @fields
      end
    end

    class FieldDefinition
      def initialize
        @included_fields = []
      end

      def fields(*field_names)
        @included_fields.concat(field_names)
      end

      def to_h
        {
          fields: @included_fields
        }
      end
    end
  end
end
