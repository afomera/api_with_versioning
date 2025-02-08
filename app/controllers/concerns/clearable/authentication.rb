# frozen_string_literal: true

module Clearable::Authentication
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token

    before_action :authenticate_api_credentials!

    protected

    # Returns the current authenticated account
    def current_account
      @current_account ||= @api_credentials&.account
    end

    # Returns the model class used for API credentials (defaults to Api::SecretKey)
    def credential_model
      Api::SecretKey
    end

    private

    def authenticate_api_credentials!
      authenticate_token || authenticate_basic || render_unauthorized
    rescue StandardError => e
      Rails.logger.error "Authentication error: #{e.message}"
      render_unauthorized
    end

    def authenticate_token
      pattern = /^Bearer /i
      header = request.authorization
      if header && header.match(pattern)
        token = header.gsub(pattern, "").strip
        authenticate_api_credentials(token: token)
      end
    end

    def authenticate_basic
      authenticate_with_http_basic do |username, _password|
        authenticate_api_credentials(token: username)
      end
    end

    def authenticate_api_credentials(token:)
      return false if token.blank?

      begin
        normalized_token = token.encode("UTF-8", "UTF-8", invalid: :replace, undef: :replace, replace: "")
        @api_credentials = credential_model.find_by_token(normalized_token)
        return validate_mode if @api_credentials
        false
      rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError => e
        Rails.logger.error "Token encoding error: #{e.message}"
        false
      end
    end

    def render_unauthorized(error: "Invalid API credentials.", message: "Please provide valid credentials using Bearer token or Basic auth.")
      headers["WWW-Authenticate"] = 'Bearer realm="Application"'
      render json: { error: error, message: message }, status: :unauthorized
    end

    def validate_mode
      detected_mode = detect_mode_from_token(@api_credentials.token)
      if @api_credentials.mode == detected_mode
        Current.mode = detected_mode
        return true
      end

      render_unauthorized(
        error: "Invalid API key format.",
        message: "The API key format does not match its mode. Expected #{detected_mode} mode key format."
      )
      false
    end

    def detect_mode_from_token(token)
      case token
      when /^sk_live_/
        'live'
      when /^sk_test_/
        'test'
      else
        'test' # Default to test mode for safety
      end
    end

    def live_mode?
      @api_credentials&.live? || false
    end

    def test_mode?
      @api_credentials&.test? || true
    end
  end
end
