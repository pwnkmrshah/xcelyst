# frozen_string_literal: true

module BxBlockPrivacySettings
  class PrivacyPoliciesController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[show], raise: false

    def show
      unless BxBlockPrivacySettings::PrivacyPolicy.exists?
        return render json: { message: 'Private Policy not found'}, status: :not_found
      end

      serializer = BxBlockPrivacySettings::PrivacyPolicySerializer.new(BxBlockPrivacySettings::PrivacyPolicy.first)
      render json: serializer.serializable_hash,
             status: :ok
    end
  end
end
