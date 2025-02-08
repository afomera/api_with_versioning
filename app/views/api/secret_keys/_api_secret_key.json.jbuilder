json.extract! api_secret_key, :id, :token, :account_id, :created_at, :updated_at
json.url api_secret_key_url(api_secret_key, format: :json)
