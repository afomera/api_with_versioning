# Clearable Authentication

This module provides authentication support for Rails API controllers using either Bearer tokens or Basic authentication.

## Setup

1. Include the authentication module in your API controllers:

```ruby
class Api::BaseController < ApplicationController
  include Clearable::Authentication
  include Clearable::Errors # Optional but recommended for error handling
end
```

2. Ensure you have the Api::SecretKey model set up with:
   - A `token` string column (with unique index)
   - A `belongs_to :account` association
   - The `Clearable::SecureToken` concern included

## Usage

### Bearer Token Authentication

Send requests with the Bearer token in the Authorization header:

```
Authorization: Bearer sk_your_token_here
```

### Basic Authentication

Send requests with Basic auth, using the token as the username (password is ignored):

```
Authorization: Basic base64(sk_your_token_here:)
```

### Accessing the Authenticated Account

In your controllers, you can access the authenticated account using:

```ruby
def show
  current_account # Returns the authenticated account
end
```

### Customizing the Credential Model

By default, the module uses `Api::SecretKey` as the credential model. You can override this by defining `credential_model` in your controller:

```ruby
def credential_model
  MyCustomCredential
end
```

## Error Handling

The module will respond with a 401 Unauthorized status and JSON error message for:

- Missing authentication
- Invalid tokens
- Malformed tokens
- Encoding issues

Example error response:

```json
{
  "error": "Invalid API credentials.",
  "message": "Please provide valid credentials using Bearer token or Basic auth."
}
```
