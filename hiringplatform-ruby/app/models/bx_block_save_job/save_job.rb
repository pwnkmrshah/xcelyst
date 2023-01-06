module BxBlockSaveJob
  class SaveJob < ApplicationRecord
    self.table_name = :save_jobs
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    belongs_to :role, class_name: "BxBlockRolesPermissions::Role"
    validate :allready_applied, on: :create

    private

    def allready_applied
      if BxBlockSaveJob::SaveJob.exists?(role_id: self.role_id, profile_id: self.profile_id)
        errors.add(:base, "You all ready save job for this job")
      end
    end
  end
end
