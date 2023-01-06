module BxBlockBusinessFunction
  class BusinessSubCategory < ApplicationRecord
    self.table_name = :business_sub_categories
    validates :name, :business_category_id, presence: true
    belongs_to :business_category, class_name: "BxBlockBusinessFunction::BusinessCategory"
  end
end
