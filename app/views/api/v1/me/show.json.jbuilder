render_versioned_fields(json, @account, :account)
json.object "account"

if version_fields(:api_credentials)
  json.api_credentials @account.api_secret_keys do |key|
    render_versioned_fields(json, key, :api_credentials)
    json.object "api_secret_key"
  end
end
