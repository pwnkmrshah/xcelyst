# frozen_string_literal: true

module BxBlockPrivacySettings
  class PrivacyPolicy < ApplicationRecord
    self.table_name = :privacy_policies
    validate :create_only_one, on: :create

    validates :description, presence: true

    private

    def create_only_one
      errors.add(:base, "There can only be one privacy policy") if PrivacyPolicy.count > 0
    end
  end
end
