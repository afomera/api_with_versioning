# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include Clearable::Authentication
      include Clearable::Errors

      before_action :set_api_version

      rescue_from Api::Resources::Base::ValidationError,
                ActionController::BadRequest do |e|
        render_error(:bad_request, e.message)
      end

      private

      def set_api_version
        @api_version = request.headers["App-Version"] || Api::VersionChanges.latest_version
      end

      def transform_response(data)
        Api::VersionChanges.transform_response(data, @api_version)
      end

      def render_error(status, message)
        render json: { error: message }, status: status
      end
    end
  end
end
