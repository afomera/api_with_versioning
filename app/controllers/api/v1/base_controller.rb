# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include Clearable::Authentication
      include Clearable::Errors

      helper Api::VersionHelper

      rescue_from Api::Version::InvalidVersionError do |e|
        render_error(:bad_request, e.message)
      end

      rescue_from ActionController::BadRequest do |e|
        render_error(:bad_request, e.message)
      end

      private

      def render_error(status, message)
        render json: { error: message }, status: status
      end
    end
  end
end
