class Account < ApplicationRecord
  has_many :api_secret_keys, class_name: "Api::SecretKey"

  self.id_prefix = "acc"

  def name
    "Test account name"
  end
end
