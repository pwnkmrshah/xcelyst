class BxBlockPreferredOverallExperiences::PreferredSkillLevel < ApplicationRecord
    self.table_name = :preferred_skill_levels
    validates :experiences_year, :level, presence: true
    validates_format_of :level, :with => /^[a-zA-Z\s-]*$/,:message =>"Number not allowed",:multiline => true 
end
