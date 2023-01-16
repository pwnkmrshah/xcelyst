module BxBlockContentManagement
  class ContentText < ApplicationRecord
    include Contentable

    self.table_name = :content_texts
    has_many_attached :images_file, dependent: :destroy
    validates_presence_of :headline, :content
    validates_format_of :headline, :with => /^[a-z\d\-_\s]+$/i, :multiline => true , message: "special character not allowed"
    belongs_to :content_type, class_name: "BxBlockContentManagement::ContentType"
    # has_many :images, as: :attached_item, dependent: :destroy, class_name: 'BxBlockContentManagement::Image'
    has_many :videos, as: :attached_item, dependent: :destroy, class_name: 'BxBlockContentManagement::Video'
    accepts_nested_attributes_for :videos, allow_destroy: true
    # accepts_nested_attributes_for :images, allow_destroy: true

    def name
      headline
    end

    def description
      content
    end

    def image_url
      images.first.image_url if images.present?
    end

    def video_url
      videos.first.video_url if videos.present?
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end
  end
end
