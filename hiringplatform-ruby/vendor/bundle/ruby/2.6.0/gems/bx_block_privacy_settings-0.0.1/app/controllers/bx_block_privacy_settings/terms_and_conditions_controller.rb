# frozen_string_literal: true

module BxBlockPrivacySettings
  class TermsAndConditionsController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[show], raise: false

    def show
      unless BxBlockPrivacySettings::TermsAndCondition.exists?
        return render json: { message: 'Terms and Conditions not found'}, status: :not_found
      end

      serializer = TermsAndConditionsSerializer.new(TermsAndCondition.first)
      render json: serializer.serializable_hash,
             status: :ok
    end
  end
end
