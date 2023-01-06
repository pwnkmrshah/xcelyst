module BxBlockDomainCategory
    class DomainCategory < ApplicationRecord
        self.table_name = :domain_categories
        validates :name, presence: true
        belongs_to :domain, class_name: 'BxBlockDomain::Domain'
        has_many :domain_sub_category,  class_name: 'BxBlockDomainSubCategory::DomainSubCategory', dependent: :destroy
    end
end
  