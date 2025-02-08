# frozen_string_literal: true

module Api
  module Resources
    class Account < Base
      required :id, String
      required :object, String
      # required :email, String
      required :name, String
      required :created, Integer
      required :updated_at, String
      required :metadata, Hash
      required :livemode, FalseClass
      optional :api_credentials, Array
      optional :api_credential, Hash
    end

    class ApiCredential < Base
      required :id, String
      required :object, String
      required :token, String
      required :created, Integer
      required :livemode, FalseClass
      required :metadata, Hash
    end
  end
end
