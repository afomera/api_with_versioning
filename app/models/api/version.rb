# frozen_string_literal: true

module Api
  class Version
    include Comparable

    attr_reader :date

    def initialize(version_string)
      @date = Date.parse(version_string)
    rescue Date::Error
      raise InvalidVersionError, "Invalid version format: #{version_string}. Expected format: YYYY-MM-DD"
    end

    def to_s
      date.iso8601
    end

    def <=>(other)
      date <=> other.date
    end

    class InvalidVersionError < StandardError; end
  end
end
