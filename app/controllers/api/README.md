# API Versioning System

This API uses a date-based versioning system that allows for flexible changes to response structures while maintaining backward compatibility. The response format follows Stripe's API style.

## Version Format

Versions are specified using ISO 8601 dates (YYYY-MM-DD). For example:

- `2025-02-07`
- `2025-02-06`

## Making API Requests

Include the version in the `Accept` header:

```
Accept: application/json; version=2025-02-07
```

If no version is specified, the latest version will be used.

## Defining Versioned Responses

Controllers can define different response structures for different versions using the `versioned_response` DSL:

```ruby
class ExampleController < Api::V1::BaseController
  include Api::VersionedResponse

  versioned_response do
    version "2025-02-07" do
      field :account do
        fields :id, :email, :name, :created, :updated_at, :metadata, :livemode
      end
      field :api_credentials do
        fields :id, :token, :created, :livemode, :metadata
      end
    end

    version "2025-02-06" do
      field :account do
        fields :id, :email, :name, :created, :updated_at, :metadata, :livemode
      end
      # api_credentials not included in this version
    end
  end
end
```

## Response Templates

Use the versioning helpers in your JBuilder templates:

```ruby
# Root-level fields
render_versioned_fields(json, @account, :account)
json.object "account"

# Collection with nested objects
if version_fields(:api_credentials)
  json.api_credentials @account.api_secret_keys do |key|
    render_versioned_fields(json, key, :api_credentials)
    json.object "api_credential"
  end
end
```

## Example Responses

### Version 2025-02-07

```json
{
  "id": "acc_123",
  "object": "account",
  "email": "user@example.com",
  "name": "User",
  "created": 1707345600,
  "updated_at": "2025-02-07T12:00:00Z",
  "metadata": {},
  "livemode": false,
  "api_credentials": [
    {
      "id": "sk_123",
      "object": "api_credential",
      "token": "sk_123",
      "created": 1707345600,
      "livemode": false,
      "metadata": {}
    }
  ]
}
```

### Version 2025-02-06

```json
{
  "id": "acc_123",
  "object": "account",
  "email": "user@example.com",
  "name": "User",
  "created": 1707345600,
  "updated_at": "2025-02-07T12:00:00Z",
  "metadata": {},
  "livemode": false
}
```

## Error Handling

Invalid or unsupported versions will return a 400 Bad Request response:

```json
{
  "error": "Invalid version format: 2025-13-45. Expected format: YYYY-MM-DD"
}
```

or

```json
{
  "error": "Unsupported API version: 2024-01-01"
}
```
