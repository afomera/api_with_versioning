# frozen_string_literal: true

module Api
  class VersionChanges
    VERSIONS = {
      "2025-02-06" => [
        Changes::AddApiCredentials
      ],
      "2025-02-07" => [
        Changes::CollapseApiCredentials
      ]
    }.freeze

    class << self
      def for_version(version_date)
        changes = []
        VERSIONS.each do |date, version_changes|
          next if date > version_date
          changes.concat(version_changes)
        end
        Rails.logger.info "Applying changes for version #{version_date}: #{changes.map(&:name)}"
        changes
      end

      def latest_version
        VERSIONS.keys.max
      end

      def transform_response(data, version)
        Rails.logger.info "Transforming response for version #{version}"
        Rails.logger.info "Original data: #{data.inspect}"
        
        changes = for_version(version)
        result = changes.reduce(data) do |acc, change|
          Rails.logger.info "Applying change #{change.name}"
          transformed = change.transform(acc)
          Rails.logger.info "After #{change.name}: #{transformed.inspect}"
          transformed
        end

        Rails.logger.info "Final transformed data: #{result.inspect}"
        result
      end
    end
  end
end
