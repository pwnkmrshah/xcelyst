module BxBlockDomainSubCategory
    class DomainSubCategory < ApplicationRecord
        self.table_name = :domain_sub_categories
        validates :name, presence: true
        belongs_to :domain_category, class_name: 'BxBlockDomainCategory::DomainCategory'
        has_many :skill_matrices, class_name: 'BxBlockSkillMatrice::SkillMatrice'
        has_many :job_descriptions, through: :skill_matrices, class_name: 'BxBlockJobDescription::JobDescription'
    end
end
  