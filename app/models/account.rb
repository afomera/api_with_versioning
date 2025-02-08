class Account < ApplicationRecord
  has_many :api_secret_keys, class_name: "Api::SecretKey"
  has_many :live_keys, -> { live }, class_name: "Api::SecretKey"
  has_many :test_keys, -> { test }, class_name: "Api::SecretKey"

  validates :livemode, inclusion: { in: [true, false] }

  def name
    "Test account name"
  end

  def create_secret_key(mode: nil)
    mode ||= livemode? ? 'live' : 'test'
    api_secret_keys.create!(mode: mode)
  end

  def test!
    update!(livemode: false)
  end

  def live!
    update!(livemode: true)
  end
end
