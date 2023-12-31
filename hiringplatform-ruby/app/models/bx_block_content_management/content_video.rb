module BxBlockContentManagement
  class ContentVideo < ApplicationRecord
    include Contentable

    self.table_name = :content_videos

    validates_presence_of :headline ,:separate_section
    belongs_to :content_type, class_name: "BxBlockContentManagement::ContentType"
    has_one_attached :image_file, dependent: :destroy
    has_one_attached :video_file, dependent: :destroy
    validates_format_of :separate_section, :headline, :with => /^[a-zA-Z\s]*$/,:message =>"Number & character not allowed",:multiline => true
    validates :content_type_id, presence: true
    # has_one :video, as: :attached_item, dependent: :destroy, class_name: 'BxBlockContentManagement::Video'
    # has_one :image, as: :attached_item, dependent: :destroy, class_name: 'BxBlockContentManagement::Image'
    # accepts_nested_attributes_for :video, allow_destroy: true
    # accepts_nested_attributes_for :image, allow_destroy: true

    def name
      headline
    end

    # def image_url
    #   image.image_url if image.present?
    # end

    # def video_url
    #   video.video_url if video.present?
    # end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end

    private

    def validate_video_short_length
      if self.video.present? and self.video.video.present?
        errors.add(:video, "can't be more than 30 seconds") if get_time_duration(self.video.video) >= 30
      end
    end

    def validate_video_full_length
      if self.video.present? and self.video.video.present?
        errors.add(:video, "can't be less than 30 seconds") if get_time_duration(self.video.video) < 30
      end
    end

    def get_time_duration(video)
      movie = FFMPEG::Movie.new(video.current_path)
      movie.duration
    end
  end
end
