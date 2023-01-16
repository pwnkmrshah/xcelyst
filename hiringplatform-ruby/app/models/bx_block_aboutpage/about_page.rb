class BxBlockAboutpage::AboutPage < ApplicationRecord
  has_one_attached :image_file
  validates_format_of :title, :with => /^[a-zA-Z\s?&'_-]*$/, :multiline => true, message: "Special character & Number not allowed"
end
