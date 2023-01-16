module BxBlockPreferredOverallExperiences
  class PreferredOverallExperiences < BxBlockProfile::ApplicationRecord
    self.table_name = :preferred_overall_experiences
    validates :experiences_year, :level, :grade, presence: true
    validates :experiences_year, :uniqueness => true
    validates_format_of :level, :grade, :with => /^[a-zA-Z\s-]*$/, :message => "Number not allowed", :multiline => true
  end
end
