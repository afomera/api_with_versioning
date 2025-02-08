# frozen_string_literal: true

module Api
  module V1
    class MeController < BaseController
      include Api::VersionedResponse

      versioned_response do
        version "2025-02-07" do
          field :account do
            fields :id, :name, :created, :updated_at, :metadata, :livemode
          end
          field :api_credentials do
            fields :id, :token, :created, :livemode, :metadata
          end
        end

        version "2025-02-06" do
          field :account do
            fields :id, :name, :created, :updated_at, :metadata, :livemode
          end
          # api_credentials not included in this version
        end
      end

      def show
        @account = current_account
      end
    end
  end
end
