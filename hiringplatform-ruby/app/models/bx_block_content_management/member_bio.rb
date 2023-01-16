module BxBlockContentManagement
    class MemberBio < ApplicationRecord
      include Contentable
  
      self.table_name = :members_bios
      has_one_attached :image_file, dependent: :destroy
      validates_presence_of :name, :position, :description, :order
      validates_uniqueness_of :order, scope: :content_type_id
      belongs_to :content_type, class_name: "BxBlockContentManagement::ContentType"
      validates_format_of :name, :with => /^[a-zA-Z\s]*$/,:message => "Number & character not allowed" ,:multiline => true 
  end
end