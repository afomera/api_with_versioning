class Api::SecretKey < ApplicationRecord
  include Clearable::SecureToken

  belongs_to :account

  validates :mode, presence: true, inclusion: { in: %w[live test] }
  
  scope :live, -> { where(mode: 'live') }
  scope :test, -> { where(mode: 'test') }

  before_validation :set_mode_from_account, on: :create
  before_create :set_token_with_mode

  def self.secure_token_prefix
    "sk"
  end

  def self.generate_unique_secure_token(length: 24)
    mode_str = Thread.current[:generating_token_mode] || 'test'
    "#{secure_token_prefix}_#{mode_str}_#{super(length: length)}"
  end

  def self.generate_token(mode: 'test')
    Thread.current[:generating_token_mode] = mode
    token = generate_unique_secure_token
    Thread.current[:generating_token_mode] = nil
    token
  end

  def metadata
    {
      mode: mode,
      livemode: live?
    }
  end

  def live?
    mode == 'live'
  end

  def test?
    mode == 'test'
  end

  private

  def set_token_with_mode
    self.token = self.class.generate_token(mode: mode)
  end

  def set_mode_from_account
    self.mode ||= account&.livemode? ? 'live' : 'test'
  end
end
