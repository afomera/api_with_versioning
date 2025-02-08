class Api::SecretKey < ApplicationRecord
  include Clearable::SecureToken

  belongs_to :account

  def self.secure_token_prefix
    "sk"
  end
end
