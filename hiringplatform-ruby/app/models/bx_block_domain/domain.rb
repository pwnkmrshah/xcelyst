module BxBlockDomain
    class Domain < ApplicationRecord
        self.table_name = :domains
        validates :name, presence: true
        has_many :domain_category,  class_name: 'BxBlockDomainCategory::DomainCategory',  dependent: :destroy
    end
end
  