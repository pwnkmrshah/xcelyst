module BxBlockContentManagement
  class SocialMediaLink < ApplicationRecord
    self.table_name = :social_media_links
    # validates :link, url: true
  end
end
