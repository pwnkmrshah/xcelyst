module BxBlockBusinessFunction
  class BusinessCategory < ApplicationRecord
    self.table_name = :business_categories
    validates :name, :business_domain_id, presence: true
    belongs_to :business_domain, class_name: "BxBlockBusinessFunction::BusinessDomain"
    has_many :business_sub_categories, class_name: "BxBlockBusinessFunction::BusinessSubCategory", dependent: :destroy
  end
end
