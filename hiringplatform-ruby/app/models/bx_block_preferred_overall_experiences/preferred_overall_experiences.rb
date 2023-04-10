module BxBlockPreferredOverallExperiences
  class PreferredOverallExperiences < BxBlockProfile::ApplicationRecord
    self.table_name = :preferred_overall_experiences
    validates :level, :grade, presence: true, if: -> { level.present? }
    validates :experiences_year, presence: true
    validates_format_of :level, :grade, :with => /^[a-zA-Z\s-]*$/, :message => "Number not allowed", :multiline => true
  end
end
