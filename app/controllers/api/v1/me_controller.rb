# frozen_string_literal: true

module Api
  module V1
    class MeController < BaseController
      def show
        @account = current_scope.find(current_account.id)
        render json: transform_response(account_data)
      end

      private

      def account_data
        {
          id: @account.id,
          object: "account",
          name: @account.name,
          created: @account.created_at.to_i,
          updated_at: @account.updated_at.iso8601,
          metadata: {},
          livemode: @account.livemode?
        }
      end

      def current_scope
        @current_scope ||= begin
          if @api_credentials.live?
            Account.where(livemode: true)
          else
            Account.where(livemode: false)
          end
        end
      end
    end
  end
end
