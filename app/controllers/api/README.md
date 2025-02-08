# API Versioning System

Our API uses a date-based versioning system that allows for flexible changes while maintaining backward compatibility. Each change is encapsulated in its own class, making it easy to track and understand API evolution over time.

## Version Format

Versions are specified using ISO 8601 dates (YYYY-MM-DD) in the `App-Version` header:

```
App-Version: 2025-02-07
```

If no version is specified, the latest version will be used.

## How Changes Work

Each change to the API is defined as a separate class that:

1. Documents what changed
2. Specifies which resource types it affects
3. Defines the type changes (e.g., Array to Hash)
4. Implements the transformation logic

Example:

```ruby
class CollapseApiCredentials < AbstractVersionChange
  description \
    "Account responses will now include a single api_credential object " \
    "instead of an array of api_credentials. This simplifies the API " \
    "by only exposing the primary API key."

  response Resources::Account do
    change :api_credentials, type_old: Array, type_new: NilClass
    change :api_credential, type_old: NilClass, type_new: Hash

    run do |data|
      if data[:api_credentials]&.any?
        data.merge(
          api_credential: data[:api_credentials].first
        ).except(:api_credentials)
      else
        data.except(:api_credentials)
      end
    end
  end
end
```

## Version History

### 2025-02-07

- Changed: Account responses now include a single `api_credential` object instead of an array of `api_credentials`
- Reason: Simplify the API by only exposing the primary API key

### 2025-02-06

- Added: Account responses now include an array of `api_credentials`
- Reason: Allow clients to access their API keys

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
  "api_credential": {
    "id": "sk_123",
    "object": "api_credential",
    "token": "sk_123",
    "created": 1707345600,
    "livemode": false,
    "metadata": {}
  }
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

## Error Handling

Invalid or unsupported versions will return a 400 Bad Request response:

```json
{
  "error": "Invalid version format: 2025-13-45. Expected format: YYYY-MM-DD"
}
```

## Adding New Changes

1. Create a new class in `app/models/api/changes/` that inherits from `AbstractVersionChange`
2. Document the change with a clear description
3. Specify which resource type it affects
4. Define the field and type changes
5. Implement the transformation logic
6. Add the change to `Api::VersionChanges::VERSIONS` with its effective date
