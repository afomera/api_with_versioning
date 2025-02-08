# frozen_string_literal: true

module Api
  module Changes
    class CollapseApiCredentials < AbstractVersionChange
      description \
        "Account responses will now include a single api_credential object " \
        "instead of an array of api_credentials. This simplifies the API " \
        "by only exposing the primary API key."

      response Resources::Account do
        change :api_credentials, type_old: Array, type_new: NilClass
        change :api_credential, type_old: NilClass, type_new: Hash

        run do |data|
          account = Account.find(data[:id].sub(/^acc_/, ''))
          credentials = Api::ApiCredentialSerializer.serialize(account.api_secret_keys.first)
          
          data = data.except(:api_credentials)
          
          if credentials.any?
            data.merge(api_credential: credentials.first)
          else
            data
          end
        end
      end
    end
  end
end
