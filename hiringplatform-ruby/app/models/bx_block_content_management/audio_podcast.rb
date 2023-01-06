module BxBlockContentManagement
  class AudioPodcast < ApplicationRecord
    include Contentable

    self.table_name = :audio_podcasts

    validates_presence_of :heading
    belongs_to :content_type, class_name: "BxBlockContentManagement::ContentType"
    has_one_attached :image_file, dependent: :destroy
    # has_one :image, as: :attached_item, dependent: :destroy
    has_one :audio, as: :attached_item, dependent: :destroy

    # accepts_nested_attributes_for :image, allow_destroy: true
    accepts_nested_attributes_for :audio, allow_destroy: true
    validates_format_of :heading, :with => /^[a-zA-Z\s]*$/, message: "Special character & Number are not allowed", :multiline => true
    # validates :content_type_id, presence: true
    validates :content_type_id,:image_file, presence: true

    def name
      heading
    end

    def image_url
      image.image_url if image.present?
    end

    def video_url
      nil
    end

    def audio_url
      audio.audio_url if audio.present?
    end

    def study_material_url
      nil
    end
  end

end
