# frozen_string_literal: true

module Api
  module Changes
    class AddApiCredentials < AbstractVersionChange
      description \
        "Account responses will now include an array of api_credentials " \
        "containing the account's API keys."

      response Resources::Account do
        change :api_credentials, type_old: NilClass, type_new: Array

        run do |data|
          account = Account.find(data[:id])
          data.merge(
            api_credentials: Api::ApiCredentialSerializer.serialize(account.api_secret_keys)
          )
        end
      end
    end
  end
end
