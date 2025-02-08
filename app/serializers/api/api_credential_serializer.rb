# frozen_string_literal: true

module Api
  class ApiCredentialSerializer
    class << self
      def serialize(keys)
        Array(keys).map do |key|
          {
            id: key.token,
            object: "api_credential",
            token: key.token,
            created: key.created_at.to_i,
            livemode: false,
            metadata: {}
          }
        end
      end
    end
  end
end
