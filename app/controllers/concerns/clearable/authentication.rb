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
      rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError => e
        Rails.logger.error "Token encoding error: #{e.message}"
        false
      end
    end

    def render_unauthorized
      headers["WWW-Authenticate"] = 'Bearer realm="Application"'
      render json: { 
        error: "Invalid API credentials.",
        message: "Please provide valid credentials using Bearer token or Basic auth."
      }, status: :unauthorized
    end
  end
end
