# frozen_string_literal: true

module BxBlockPrivacySettings
  class TermsAndCondition < ApplicationRecord
    self.table_name = :terms_and_conditions
    validates :description, presence: true
    validate :create_only_one, on: :create

    private

    def create_only_one
      errors.add(:base, "There can only be one terms and conditions") if TermsAndCondition.count > 0
    end
  end
end
