module BxBlockContentManagement
  class ContentType < ApplicationRecord
    self.inheritance_column = nil
    self.table_name = :content_types

    TYPE_MAPPINGS = {
      "Text" => BxBlockContentManagement::ContentText.name,
      "Videos" => BxBlockContentManagement::ContentVideo.name,
      "Live Stream" => BxBlockContentManagement::LiveStream.name,
      "AudioPodcast" => BxBlockContentManagement::AudioPodcast.name,
      "Test" => BxBlockContentManagement::Test.name,
      "Epub" => BxBlockContentManagement::Epub.name,
      "MemberBio" => BxBlockContentManagement::MemberBio.name,
    }.freeze

    validates_presence_of :name, :type
    validates_uniqueness_of :name, case_sensitive: false
    validates_format_of :name, :with => /^[a-zA-Z\s]*$/, message: "Special character & Number are not allowed", :multiline => true
    # validates_uniqueness_of :identifier, allow_blank: true
    has_many :content_text, class_name: "BxBlockContentManagement::ContentText", dependent: :destroy
    has_many :content_video, class_name: "BxBlockContentManagement::ContentVideo", dependent: :destroy
    has_many :audio_podcast, class_name: "BxBlockContentManagement::AudioPodcast", dependent: :destroy
    has_many :epub, class_name: "BxBlockContentManagement::Epub", dependent: :destroy
    has_many :member_bio, class_name: "BxBlockContentManagement::MemberBio", dependent: :destroy
    has_many :contents, class_name: "BxBlockContentManagement::Content", dependent: :destroy

    # has_and_belongs_to_many :partners, class_name: 'BxBlockRolesPermissions::Partner',
    # join_table: :content_types_partners, dependent: :destroy

    enum type: ["Text", "Videos", "Live Stream", "AudioPodcast", "Test", "Epub", "MemberBio"]

    # enum identifier: ["news_article", "audio_podcast", "blog", "live_streaming", "quiz", "assessment",
    #                   "study_material", "video_short", "video_full"]

    def type_class
      TYPE_MAPPINGS[type]
    end
  end
end
