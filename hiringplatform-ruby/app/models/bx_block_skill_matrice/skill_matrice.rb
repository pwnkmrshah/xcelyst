module BxBlockSkillMatrice
  class SkillMatrice < ApplicationRecord
    self.table_name = :skill_matrices
    belongs_to :job_description, class_name: "BxBlockJobDescription::JobDescription"
    belongs_to :domain_sub_category, class_name: "BxBlockDomainSubCategory::DomainSubCategory"

    validate :check_experience

    def check_experience
      if self.preferred_overall_experience_ids.present?
        begin
          experience = BxBlockPreferredOverallExperiences::PreferredOverallExperiences.find(self.preferred_overall_experience_ids)
        rescue ActiveRecord::RecordNotFound => e
          self.errors.add(:base, "preferred_overall_experience ids wrong")
        end
      end
      if self.preferred_skill_level_ids.present?
        begin
          experience = BxBlockPreferredOverallExperiences::PreferredSkillLevel.find(self.preferred_skill_level_ids)
        rescue ActiveRecord::RecordNotFound => e
          self.errors.add(:base, "preferred_skill_level_ids ids wrong")
        end
      end
    end

  end
end
