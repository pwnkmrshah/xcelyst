module BxBlockBusinessFunction
  class BusinessDomain < ApplicationRecord
    self.table_name = :business_domains
    validates :name, presence: true
    has_many :business_categories, class_name: "BxBlockBusinessFunction::BusinessCategory", dependent: :destroy
  end
end
